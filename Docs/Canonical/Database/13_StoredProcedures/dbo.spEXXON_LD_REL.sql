SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spEXXON_LD_REL]'2018-01-01','2018-12-12'
CREATE PROCEDURE  [dbo].[spEXXON_LD_REL]--'2018-01-01','2018-12-12'
	--@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	
AS
select 
	p.Num_CPF_CNPJ									[Planta],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')		[REFERÊNCIA CLIENTE (PO)],
	--Soma Tx Siscomex + PIS + COFINS +II + IPI	
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%siscomex%chb%') +
		dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%pis%chb%') +
			dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%cofins%chb%') +
				dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%imposto%import%chb%') +
					dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%ipi%chb%')			[CONTA 915000039 (SISCOMEX) - CRÉDITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%siscomex%chb%')						[CONTA 520009001 (TX. SISCOMEX) - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%pis%chb%')							[CONTA 621635101(PIS)  - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%cofins%chb%')						[CONTA 621634101 (COFINS) - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%imposto%import%chb%')			[CONTA 520009001 (I.I.) - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%afrmm%chb%')						[CONTA 520009001 (AFRMM)],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%Multas - CHB%')	 +
			dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%Multa 1 - CHB%') +
				dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%Multa 2- CHB%')	+
					dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%Multa 3- CHB%')		[CONTA 43.700.784 (SISCOMEX MULTA) - DÉBITO],
	
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%ipi%chb%')							[CONTA 621535103 (IPI) - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%multa%lI%chb%')						[CONTA 43.700.784 (SISCOMEX MULTA LI) - DÉBITO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%antidumping%')						[CONTA 43.700.784 (ANTIDUMPING) - DÉBITO],
	HOU.Vessel																					[NOME DO NAVIO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%tup%chb%')							[TUP],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%sop%chb%')							[SOP],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%thc%chb%')							[THC],
	CP.Campo_Dados																				[ARQUEAÇÃO],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%liberacao%chb%')					[LIBERAÇÃO BL],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%ISPS%chb%')							[ISPS],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%siscarga%chb%')						[TAXA SISCARGA],
	HOU.ATA																						[ATRACAÇÃO],
	HOU.Frete_BL * 	convert(float,isnull(dbo.fBusca_CampoCliente(HOU.Num_Proc,31),1))			[FRETE EM REAIS],
	HOU.Frete_BL																				[FRETE EM DOLARES],
	convert(float,isnull(dbo.fBusca_CampoCliente(HOU.Num_Proc,31),1))							[ParidadeUSD],
	Hou.Num_Proc																				[JOB]
from vwhouse_imp HOU					with(nolock)
Left join Pedido_Ship PS				with(nolock) on HOU.num_proc = PS.Num_Proc
Left join Produto_Cliente PC			with(nolock) on PS.cd_produto = PC.cd_prod 
Left join Nota_Fiscal_Cliente_Det NFD	with(nolock) on PS.cd_produto = NFD.Cd_Produto and PS.cd_pedido = NFD.Cd_Pedido
Left Join Tarefas_Processos TP4			with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Left Join Pessoa P						with(nolock) on HOU.Cd_Consig = P.Cd_Pes
Left join Pessoa_LLP	PL				with(nolock) on HOU.Cd_Consig = PL.Cd_Pes
Left Join  Grupo		G				with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
Left Join  pessoa		PG				with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
Left join Campo_Processo CP				with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '168'
where	
	--HOU.Num_Proc = 'IMEXO201712008BR'	and 
	TP4.dt_conclusao between @DtInicial and @DtFinal
	and PG.Apelido = 'Grupo Exxon'
	--and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
order by TP4.dt_conclusao

GO
