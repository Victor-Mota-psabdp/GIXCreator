SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATLINT_JSON_Oxiteno_purchaseOrderContainer_Sel null,null,null,'X'
--[spATLINT_JSON_Oxiteno_purchaseOrderContainer_Sel] NULL,NULL,NULL,'I'
CREATE PROCEDURE [dbo].[spATLINT_JSON_Oxiteno_purchaseOrderContainer_Sel]
(
	@ID_purchaseOrderContainer	bigint,
	@ref_oxiteno				varchar(200),	
	@num_Proc					varchar(200),
	@Tipo						char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_purchaseOrderContainer [Internal Code],
			S.ref_oxiteno,			
			S.container,
			S.free_time,
			S.limite_arm_porto,
			S.entrada_armazem_ext,
			S.saida_armazem_ext,
			S.entrega_fabrica,
			S.saida,
			S.devolucao,
			S.local_entrega_vazio,
			S.valor_demurrage,
			S.Num_Proc				[JOB],		
			left(S.Message,2000)				[Message],
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_purchaseOrderContainer [Internal Code],
			S.ref_oxiteno,			
			S.container,
			S.free_time,
			S.limite_arm_porto,
			S.entrada_armazem_ext,
			S.saida_armazem_ext,
			S.entrega_fabrica,
			S.saida,
			S.devolucao,
			S.local_entrega_vazio,
			S.valor_demurrage,
			S.Num_Proc				[JOB],
			left(S.Message,2000)				[Message],
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	
		where 
			ID_purchaseOrderContainer = @ID_purchaseOrderContainer
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			S.ID_purchaseOrderContainer [Internal Code],
			S.ref_oxiteno,			
			S.container,
			S.free_time,
			S.limite_arm_porto,
			S.entrada_armazem_ext,
			S.saida_armazem_ext,
			S.entrega_fabrica,
			S.saida,
			S.devolucao,
			S.local_entrega_vazio,
			S.valor_demurrage,
			S.Num_Proc				[JOB],	
			left(S.Message,2000)				[Message],
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	
		where 
			S.ref_oxiteno = @ref_oxiteno
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_purchaseOrderContainer [Internal Code],
			S.ref_oxiteno,			
			S.container,
			S.free_time,
			S.limite_arm_porto,
			S.entrada_armazem_ext,
			S.saida_armazem_ext,
			S.entrega_fabrica,
			S.saida,
			S.devolucao,
			S.local_entrega_vazio,
			S.valor_demurrage,
			S.Num_Proc				[JOB],	
			left(S.Message,2000)				[Message],
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	
		Where
			S.Dt_Sent is null		
	End
	
if @Tipo = 'X'
	Begin
		select distinct
			NULL [Internal Code],
			PO.Numero_PO + '/' + convert(varchar(4),year(PO.Data_PO))	ref_oxiteno,

			replace(VCont.Num_Cont,'-','')						container,
			CP138.Campo_Dados					free_time,
			(Case when CP149.Campo_Dados is null or CP149.Campo_Dados ='' then 
				Convert(Datetime,CP150.Campo_Dados,103)	
			else
				Convert(Datetime,CP149.Campo_Dados,103)	
			end)											limite_arm_porto,
			--Convert(Datetime,CP150.Campo_Dados,103)		limite_arm_porto,

			--5 – entrada_armazem_ext = JOB/Container/Additional Information/Entrega no armazem
			--CON.dt_entregaPlanta				entrada_armazem_ext,
			CON.dt_entregaArmazem				entrada_armazem_ext,

			--6 – saida_armazem_ext = JOB/Container/Additional Information/Saida do Armazem
			--CON.dt_entregaArmazem				saida_armazem_ext,
			CON.dt_saidaArmazem					saida_armazem_ext,

			--7 – entrega_fabrica = JOB/Container/Additional Information/Entrega na planta
			--CON.dt_saidaArmazem					entrega_fabrica,
			CON.dt_entregaPlanta				entrega_fabrica,

			CON.dt_saidaVazio					saida,
			CON.dt_devolucao					devolucao,
			CON.local_entrega_vazio				local_entrega_vazio,
			(case when CP158.Campo_Dados = null or CP158.Campo_Dados = '' then null else convert(decimal(18,2),cp158.campo_dados) end)			valor_demurrage,
			HOU.Num_Proc		[JOB],	
			NULL				[Message],
			NULL			[Insert Date],
			NULL		[Sent Date],


			DateAdd(day,-120,getdate()) ,
			CON.Dt_ins [CON.Dt_ins],
			CP138.Dt_ins [CP138.Dt_ins],
			CP150.Dt_ins [CP150.Dt_ins],
			CP149.Dt_ins [CP149.Dt_ins],
			CP158.Dt_ins [CP158.Dt_ins]

		from vwHouse_Imp HOU with(nolock)
			join vwPO_Imp PO with(nolock) on PO.NUm_proc = HOU.Num_Proc
			--left join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer USO with(nolock) on USO.NUm_proc = HOU.Num_Proc			
			left join Campo_Processo CP138 with(nolock) on CP138.NUm_proc = HOU.Num_Proc and CP138.ID_Campo = 138
			left join Campo_Processo CP150 with(nolock) on CP150.NUm_proc = HOU.Num_Proc and CP150.ID_Campo = 150
			left join Campo_Processo CP149 with(nolock) on CP149.NUm_proc = HOU.Num_Proc and CP149.ID_Campo = 149
			left join Campo_Processo CP158 with(nolock) on CP158.NUm_proc = HOU.Num_Proc and CP158.ID_Campo = 158
			join [dbo].[vwContainer_IMP] VCont with(nolock) on VCont.NUm_proc = HOU.Num_Proc	
			left join Container_Additional_Info CON with(nolock) on CON.NUm_proc = HOU.Num_Proc	and replace(CON.Num_Cont,'-','') = replace(VCont.Num_Cont,'-','')		
			--join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'
			left join Tarefas_Processos TP7 with(nolock) on HOU.NUm_proc = TP7.Num_proc and TP7.ID_task = 7
		Where	
			--HOu.Num_proc = 'IMOXT202210008BR' and replace(CON.Num_Cont,'-','')  = 'DJDU7066804'		
			--EXC.ExcDataAlt >= DateAdd(hour,-1,getdate()) and 
					   			
			TP7.Dt_Conclusao is not null

			and 
			(
				CON.Dt_ins >= DateAdd(hour,-3,getdate()) 				
				or
				CP138.Dt_ins >= DateAdd(hour,-3,getdate()) 
				or
				CP150.Dt_ins >= DateAdd(hour,-3,getdate()) 
				or
				CP149.Dt_ins >= DateAdd(hour,-3,getdate()) 
				or
				CP158.Dt_ins >= DateAdd(hour,-3,getdate())
				or
				TP7.Dt_insert >= DateAdd(hour,-3,getdate())
			)

			----teste de dias
			--and 
			--(
			--	CON.Dt_ins >= DateAdd(day,-5,getdate())  
			--	or
			--	CP138.Dt_ins >= DateAdd(day,-5,getdate()) 
			--	or
			--	CP150.Dt_ins >= DateAdd(day,-5,getdate()) 
			--	or
			--	CP149.Dt_ins >= DateAdd(day,-5,getdate()) 
			--	or
			--	CP158.Dt_ins >= DateAdd(day,-10,getdate())			
			--)
			
			--EXC.ExcDataAlt > getdate() -5
			--and CON.Num_Cont is not null
			--and CON.dt_entregaPlanta is not null
			--and CON.dt_entregaArmazem is not null
			--and CON.dt_saidaArmazem is not null
			--and CON.dt_saidaVazio is not null
			--and CON.dt_devolucao is not null
			--and CON.local_entrega_vazio is not null

			--and 
			--	(
			--		(VCont.Cd_Tp_Cont =  'LCL' and (CON.dt_entregaPlanta is null or DateAdd(day,2,CON.dt_entregaPlanta) >= getdate()) )
			--	or
			--		(VCont.Cd_Tp_Cont <>  'LCL' and CON.dt_entregaPlanta  is null and CON.dt_devolucao is null)
			--	)

				--and HOU.ID_Status not in (8,9)
			
	End	


/*

select * from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer where dt_ins> '2023-02-15 12:30:43.017'

select * from Campo_Processo where num_proc like 'IMOXT202%' and id_campo = '138' and dt_ins > getdate() -10
select * from Campo_Processo where num_proc like 'IMOXT202%' and id_campo = '150' and dt_ins > getdate() -10
select * from Campo_Processo where num_proc like 'IMOXT202%' and id_campo = '149' and dt_ins > getdate() -10
select * from Campo_Processo where num_proc like 'IMOXT202%' and id_campo = '158' and dt_ins > getdate() -10
select * from Container_Additional_Info where num_proc like 'IMOXT202%' and dt_ins > getdate() -5
select * from Tarefas_processos where num_proc ='IMOXT202305026BR' and ID_task = 7

select * from tipo_Campo_cliente where id_campo = '158'
select * from vwContainer_IMP where num_proc = 'IMOXT202108071BR'

select * fro tipo_tarefas where nome_task like 

select * from tipo_tarefas where nome_task like '%planta%'
select * from Tarefas_processos where num_proc ='IMOXT202305026BR' and ID_task = 10
1 - Inicio: Quando o task: “Docs disponíveis p/ transp.” for preenchido.
1.1 - Atualizações: Será enviado atualizações quando houver qualquer alteração no job
2 - Fim: Quando todos os campos abaixo estiverem preenchidos.

select * from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer where ref_oxiteno = 'G426/2021'
update ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer set dt_sent = '2010-01-01' where ref_oxiteno = 'P328/2021'
Carga LCL
Quando no campo abaixo tiver LCL pode considerar o término quando o campo Entrega na planta estiver preenchido.
Carga embalada
São os demais tipo de FCL, pode considerar término quando os dois campos abaixo estiverem preenchidos: Entrega na planta e Dt retorno
*/

if @Tipo = 'I'--usada na tela do Integrated Received
	Begin
		select 
			S.ID_purchaseOrderContainer [Internal Code],
			S.ref_oxiteno,			
			S.container,
			S.free_time,
			S.limite_arm_porto,
			S.entrada_armazem_ext,
			S.saida_armazem_ext,
			S.entrega_fabrica,
			S.saida,
			S.devolucao,
			S.local_entrega_vazio,
			S.valor_demurrage,
			S.Num_Proc				[JOB],	
			left(S.Message,2000)				[Message],
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	
		where
			S.dt_ins > getdate() -1
			
	End

GO
