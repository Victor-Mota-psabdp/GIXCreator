SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--100-67111 - Por favor incluir critério para que o alerta não seja enviado caso o job tenha status 
--com as seguintes opções:
--Status a serem desconsiderados:
--05 - Processo encerrado
--ao
--09 - Cancelled job
--[spAlertaDescricaoCompleta_Rel] NULL,NULL,NULL,NULL
--[spAlertaDescricaoCompleta_Rel] NULL,NULL,'NULL','GRUPO AMAZONAS'
CREATE procedure [dbo].[spAlertaDescricaoCompleta_Rel]--'2015-04-01','2016-10-26','',''
(
	@DataInicial datetime,
	@DataFinal datetime,
	@Nome_Usuario varchar(50),
	@Grupo varchar(50)
)
as

set @DataInicial = '2015-04-01'
set @DataFinal = GETDATE()

If @Nome_Usuario is null
	Begin
		select 
			NG.Apelido Grupo, US.Nome_Usuario Usuario,  US.Email Email_Usuario, 
			isnull(GR.Email,'raquel.loanda@bdpint.com') Email_Gerente  
		from Pedido_Ship PS with(nolock)
		Join Pedido_Det	PD with(nolock) on PS.Cd_Pedido=PD.Cd_Pedido and PD.Cd_Produto = PS.cd_produto and PD.Lote = PS.Lote and PD.Item = PS.Item
		Join pedido P with(nolock) on P.Cd_Pedido=PD.Cd_Pedido
		Join Produto_Cliente	PC with(nolock) on PC.Cd_Prod = PS.Cd_Produto and P.Cd_Grupo = PC.Cd_Cliente
		left Join Produto_CHB CHB with(nolock) on PC.Cd_Prod = CHB.Cd_Prod 
		join Grupo GP with(nolock) on PC.cd_Cliente = GP.Cd_Pes_Grupo 
		join Pessoa NG with(nolock) on GP.Cd_Pes_Grupo =NG.Cd_Pes
		join Usuario US with(nolock) on PS.cd_usuario = US.cd_usuario
		left join Usuario GR with(nolock) on GP.Responsavel = GR.cd_usuario
		left join vwALL_JOBs V with(nolock) on V.num_proc = PS.num_proc
		where 
			PS.Dt_ins between @DataInicial and @DataFinal 
			and isNULL(CHB.Descricao_Longa,'') = '' --and left(PS.Num_Proc,1) = 'I'
			and (Isnull(V.ID_Status,1) < 5)
		group by  
			NG.Apelido, US.Nome_Usuario,  US.Email , GR.Email
		order by NG.Apelido
		option (hash join)
	End
	
else

	Begin
		select 
			NG.Apelido Grupo,  PS.Num_Proc JOB, 
			v.ETA ETA,
			P.Num_Pedido Pedido,PC.cd_prod [Code], PC.cd_Proc_Cliente [Cod Prod Cliente],
			PC.Produto_Descr [Descricao],pc.NCM_Cliente [NCM],
			PS.Lote,PS.Item, isNULL(CHB.Descricao_Longa,'')Descricao_Longa, US.Nome_Usuario  Usuario,
			isnull(GR.Nome_Usuario,'Raquel Loanda')  Responsavel, convert(varchar(10),PS.Dt_ins,103) [Dt Vinculação] 
		from Pedido_Ship PS with(nolock)
			Join Pedido_Det	PD	with(nolock) on PS.Cd_Pedido=PD.Cd_Pedido and PD.Cd_Produto = PS.cd_produto and PD.Lote = PS.Lote and PD.Item = PS.Item
			Join pedido P		with(nolock) on P.Cd_Pedido=PD.Cd_Pedido
			Join Produto_Cliente PC		with(nolock) on PC.Cd_Prod = PS.Cd_Produto and P.Cd_Grupo = PC.Cd_Cliente
			left Join Produto_CHB CHB	with(nolock) on PC.Cd_Prod = CHB.Cd_Prod 
			join Grupo GP	with(nolock) on PC.cd_Cliente = GP.Cd_Pes_Grupo 
			join Pessoa NG	with(nolock) on GP.Cd_Pes_Grupo =NG.Cd_Pes
			join Usuario US with(nolock) on PS.cd_usuario = US.cd_usuario
			left join Usuario GR with(nolock) on GP.Responsavel = GR.cd_usuario
			left join vwClienteALLJOBS V with(nolock) on V.num_proc = PS.num_proc
		where 
			PS.Dt_ins between @DataInicial and @DataFinal 
			and isNULL(CHB.Descricao_Longa,'') = '' and US.Nome_Usuario = @Nome_Usuario 
			and NG.Apelido = @Grupo  --and left(PS.Num_Proc,1) = 'I'
			and (Isnull(V.ID_Status,1) < 5)
		order by NG.Apelido,PS.Dt_ins
		option (hash join)
	End
GO
