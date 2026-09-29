SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_CapaProcesso_Rel]--'EMATL201501006BR', 'Erbson'

	@JOB varchar(16),
	@Usuario	varchar(100)
	
as

Select 
	HOU.Num_Proc_HEM	[BDP Ref],
	HOU.HAWB_HEM		[House],
	HOU.MAWB_HEM		[Master],
	JOB.Nr_Reserva		[Reserva],
	SHP.Apelido			[Exportador],
	CSN.Apelido			[Importador],
	TPO.Nome_Tp_Oper	[Incoterm],
	TPC.Nome_Tp_Carga	[Embarque],
	SUM(VOL.Qtd_Vol_EM) [Quantidade],
	HOU.Navio_HEM		[Navio],
	ARM.Nome_Armador	[Armador],
	ORG.Nome_Local		[Origem],
	DTF.Nome_Local		[Destino],
	LLP.DL_Draft_Lem	[Deadline Draft],
	LLP.DL_Cargo_Lem	[Deadline Cargo],
	LLP.DL_VGM_Lem		[Deadline VGM],
	
	Convert(varchar(10),HOU.TTime_d,103)		[Transit Time],
	(case when TPC.Nome_Tp_Carga = 'FCL' then
		convert(varchar,[dbo].[Qty_Container](@JOB)) + ' X ' + dbo.fBusca_Containers_TP(@JOB)
	else
		 convert(varchar,VOL.QTD_VOL_EM) + ' ' + TE.nome_tp_embal end)	[Container],
		 
	--novos campos 5/8/2016	
	HOU.Num_Proc_MEM	[Consolidada],
	[dbo].[fBusca_Docs_PO_Modal](HOU.Num_Proc_HEM, 1) PO,
	HOU.Viagem_HEM		[Viagem],
	Convert(varchar(10),LLP.ETD_Lem	,103)		[ETD],
	Convert(varchar(10),LLP.ETA_Lem, 103)		[ETA],
	Convert(varchar(10),LLP.ATA_Lem, 103)		[ATA],	
	
	Convert(varchar(10),T5.Dt_Conclusao,103)	[Recebimento de Booking],
	Convert(varchar(10),T58.Dt_Conclusao,103)	[Solicitacao de Booking],
	Convert(varchar(10),T66.Dt_Conclusao,103)	[Draft Enviado ao Armador],
	Convert(varchar(10),T84.Dt_Conclusao,103)	[Draft Enviado ao Shipper],
	Convert(varchar(10),T58.Dt_Conclusao,103)	[Draft Enviado ao Agente],
	Convert(varchar(10),T186.Dt_Conclusao,103)	[Transmissao VGM],
	Convert(varchar(10),T178.Dt_Conclusao,103)	[AMS],
	Convert(varchar(10),T189.Dt_Conclusao,103)	[Confirmacao Armador],
	Convert(varchar(10),T134.Dt_Conclusao,103)	[Confirmacao de Embarque],
	Convert(varchar(10),T1.Dt_Conclusao,103)	[Pre-Alert],
	Convert(varchar(10),T182.Dt_Conclusao,103)	[Siscoserv],
	Convert(varchar(10),T150.Dt_Conclusao,103)	[Pagamento ao Armador]
from House_Exp_Mar HOU With(Nolock)
	Join LLP_Exp_Mar		LLP		With(Nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_Lem
	Join Job_Exp_Mar		JOB		With(Nolock) on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
	Join Pessoa				SHP		With(Nolock) on HOU.Cd_Export_HEM = SHP.Cd_Pes
	Join Pessoa				CSN		With(Nolock) on HOU.Cd_Consig_HEM = CSN.Cd_Pes
	Left outer	Join Tipo_Oper			TPO		With(Nolock) on HOU.Cd_Tp_Oper = TPO.Cd_Tp_Oper			
	Left outer	Join Tipo_Carga			TPC		With(Nolock) on LLP.Cd_Tp_Carga = TPC.Cd_Tp_Carga
	Left Outer	Join Volume_Exp_Mar		VOL		With(Nolock) on HOU.Num_Proc_HEM = VOL.Num_Proc_HEM
	left outer	Join Tipo_Embalagem		TE		With(Nolock) on	VOL.cd_tp_embal = TE.cd_tp_embal
	Left Outer	Join Armador			ARM		With(Nolock) on LLP.Cd_Armador_Lem = ARM.Cd_Armador
	Left Outer	Join Localidade			ORG		With(Nolock) on HOU.Cd_Org_Hem = ORG.Cd_Local
	Left Outer	Join Localidade			DTF		With(Nolock) on LLP.Cd_DstFinal_Lem = DTF.Cd_Local
	
	Left Outer	Join Tarefas_Processos	T5		With(Nolock) on HOU.num_proc_hem=T5.num_proc and T5.ID_Task=5
	Left Outer	Join Tarefas_Processos	T58		With(Nolock) on HOU.num_proc_hem=T58.num_proc and T58.ID_Task=58
	Left Outer	Join Tarefas_Processos	T66		With(Nolock) on HOU.num_proc_hem=T66.num_proc and T66.ID_Task=66	
	Left Outer	Join Tarefas_Processos	T84		With(Nolock) on HOU.num_proc_hem=T84.num_proc and T84.ID_Task=84
	Left Outer	Join Tarefas_Processos	T158	With(Nolock) on HOU.num_proc_hem=T158.num_proc and T158.ID_Task=158
	Left Outer	Join Tarefas_Processos	T186	With(Nolock) on HOU.num_proc_hem=T186.num_proc and T186.ID_Task=186
	Left Outer	Join Tarefas_Processos	T178	With(Nolock) on HOU.num_proc_hem=T178.num_proc and T178.ID_Task=178	
	Left Outer	Join Tarefas_Processos	T189	With(Nolock) on HOU.num_proc_hem=T189.num_proc and T189.ID_Task=189
	Left Outer	Join Tarefas_Processos	T134	With(Nolock) on HOU.num_proc_hem=T134.num_proc and T134.ID_Task=134
	Left Outer	Join Tarefas_Processos	T1		With(Nolock) on HOU.num_proc_hem=T1.num_proc and T1.ID_Task=1
	Left Outer	Join Tarefas_Processos	T182	With(Nolock) on HOU.num_proc_hem=T182.num_proc and T182.ID_Task=182
	Left Outer	Join Tarefas_Processos	T150	With(Nolock) on HOU.num_proc_hem=T150.num_proc and T150.ID_Task=150
where 
	HOU.Num_Proc_HEM = @JOB
group by
	HOU.Num_Proc_HEM,	HOU.HAWB_HEM,	HOU.MAWB_HEM,	JOB.Nr_Reserva,SHP.Apelido,
	CSN.Apelido,	TPO.Nome_Tp_Oper,	TPC.Nome_Tp_Carga,	HOU.Navio_HEM,	ARM.Nome_Armador,
	ORG.Nome_Local,	DTF.Nome_Local,	LLP.DL_Draft_Lem,	LLP.DL_Cargo_Lem,	LLP.ETD_Lem,
	LLP.ETA_Lem,	T1.Dt_Conclusao,	HOU.TTime_d,VOL.QTD_VOL_EM,	TE.nome_tp_embal,
	HOU.Viagem_HEM,HOU.Num_Proc_MEM,LLP.ATA_Lem,T5.Dt_Conclusao,T58.Dt_Conclusao,
	T66.Dt_Conclusao,T84.Dt_Conclusao,T58.Dt_Conclusao,T186.Dt_Conclusao,T178.Dt_Conclusao,
	T189.Dt_Conclusao,T134.Dt_Conclusao,T1.Dt_Conclusao,T182.Dt_Conclusao,T150.Dt_Conclusao,
	DL_VGM_Lem

/*	

select * from Tipo_Tarefas where Nome_Task like '%siscoser%' and Ativo ='s'

Convert(varchar(10),T5.Dt_Conclusao,103)	[Recebimento de Booking],
Convert(varchar(10),T58.Dt_Conclusao,103)	[Solicitacao de Booking],
Convert(varchar(10),T66.Dt_Conclusao,103)	[Draft Enviado ao Armador],
Convert(varchar(10),T84.Dt_Conclusao,103)	[Draft Enviado ao Shipper],
Convert(varchar(10),T58.Dt_Conclusao,103)	[Draft Enviado ao Agente],
Convert(varchar(10),T186.Dt_Conclusao,103)	[Transmissao VGM],
Convert(varchar(10),T178.Dt_Conclusao,103)	[AMS],
Convert(varchar(10),T189.Dt_Conclusao,103)	[Confirmacao Armador],
Convert(varchar(10),T134.Dt_Conclusao,103)	[Confirmacao de Embarque],
Convert(varchar(10),T1.Dt_Conclusao,103)	[Pre-Alert],
Convert(varchar(10),T182.Dt_Conclusao,103)	[Siscoserv],
Convert(varchar(10),T150.Dt_Conclusao,103)	[Pagamento ao Armador],

	
Left Outer	Join Tarefas_Processos	T5		With(Nolock) on HOU.num_proc_hem=T5.num_proc and T5.ID_Task=5
Left Outer	Join Tarefas_Processos	T58		With(Nolock) on HOU.num_proc_hem=T58.num_proc and T58.ID_Task=58
Left Outer	Join Tarefas_Processos	T66		With(Nolock) on HOU.num_proc_hem=T66.num_proc and T66.ID_Task=66	
Left Outer	Join Tarefas_Processos	T84		With(Nolock) on HOU.num_proc_hem=T84.num_proc and T84.ID_Task=84
Left Outer	Join Tarefas_Processos	T158	With(Nolock) on HOU.num_proc_hem=T158.num_proc and T158.ID_Task=158
Left Outer	Join Tarefas_Processos	T186	With(Nolock) on HOU.num_proc_hem=T186.num_proc and T186.ID_Task=186
Left Outer	Join Tarefas_Processos	T178	With(Nolock) on HOU.num_proc_hem=T178.num_proc and T178.ID_Task=178	
Left Outer	Join Tarefas_Processos	T189	With(Nolock) on HOU.num_proc_hem=T189.num_proc and T189.ID_Task=189
Left Outer	Join Tarefas_Processos	T134	With(Nolock) on HOU.num_proc_hem=T134.num_proc and T134.ID_Task=134
Left Outer	Join Tarefas_Processos	T1		With(Nolock) on HOU.num_proc_hem=T1.num_proc and T1.ID_Task=1
Left Outer	Join Tarefas_Processos	T182	With(Nolock) on HOU.num_proc_hem=T182.num_proc and T182.ID_Task=182
Left Outer	Join Tarefas_Processos	T150	With(Nolock) on HOU.num_proc_hem=T150.num_proc and T150.ID_Task=150

1)	Booking Solicitado - 58 - Solicitação de Booking
2)	Booking Confirmado - ?
3)	Booking Enviado - ?
4)	Dt Coleta/ Horário/ Transportador (EXW) - ?
5)	Envio de Docs IMO - 149	Envio de Docs IMO
6)	Pre-Advise Agente - ?
7)	Draft Recebido - 83	Recebimento do Draft
8)	Draft Enviado - 66	Envio do draft do BL


9) A.M.S.  - Task: 178	Registro AMS
10) ISF - Task: 179	Envio ISF
11) Confirmação de Embarque - Task: 134	Confirmação de Embarque
12) Pre-Alert - Task: 1	Envio do pré-alerta
13) Recebimento do Shipper - Task: 
14) Pagamento Armador - Task: 150	Pagto Frete e Taxas ao Armador
15) Chegada no Destino - Task: ?

*/


/*
ALTER procedure [dbo].[spATL_CapaProcesso_Rel]--'EMATL201210015BR', 'Erbson'

	@JOB varchar(16),
	@Usuario	varchar(100)
	
as

Select 
	HOU.Num_Proc_HEM	[BDP Ref],
	HOU.HAWB_HEM		[House],
	HOU.MAWB_HEM		[Master],
	JOB.Nr_Reserva		[Reserva],
	SHP.Apelido			[Exportador],
	CSN.Apelido			[Importador],
	TPO.Nome_Tp_Oper	[Incoterm],
	TPC.Nome_Tp_Carga	[Embarque],
	SUM(VOL.Qtd_Vol_EM) [Quantidade],
	HOU.Navio_HEM		[Navio],
	ARM.Nome_Armador	[Armador],
	ORG.Nome_Local		[Origem],
	DTF.Nome_Local		[Destino],
	Convert(varchar(10),LLP.DL_Draft_Lem, 103)	[Deadline Draft],
	Convert(varchar(10),LLP.DL_Cargo_Lem,103)	[Deadline Cargo],
	Convert(varchar(10),LLP.ETD_Lem	,103)		[Esperado],
	Convert(varchar(10),LLP.ATD_Lem, 103)			[Embarcado],
	Convert(varchar(10),TT1.Dt_Conclusao,103)[Pre Alert],
	Convert(varchar(10),TT4.Dt_Conclusao,103)		[Customs Clearence],
	Convert(varchar(10),HOU.TTime_d,103)			[Transit Time],
	Convert(varchar(10),TT83.Dt_Conclusao,103)	[Draft Recebido],
	Convert(varchar(10),TT66.Dt_Conclusao,103)	[Draft Enviado ao Armador],
	(case when TPC.Nome_Tp_Carga = 'FCL' then
		convert(varchar,[dbo].[Qty_Container](@JOB)) + ' X ' + dbo.fBusca_Containers_TP(@JOB)
	else
		 convert(varchar,VOL.QTD_VOL_EM) + ' ' + TE.nome_tp_embal end)	[Container]
from
	House_Exp_Mar HOU With(Nolock)
Left Outer	Join Job_Exp_Mar		JOB		With(Nolock) on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
			Join Pessoa				SHP		With(Nolock) on HOU.Cd_Export_HEM = SHP.Cd_Pes
			Join Pessoa				CSN		With(Nolock) on HOU.Cd_Consig_HEM = CSN.Cd_Pes
Left outer	Join Tipo_Oper			TPO		With(Nolock) on HOU.Cd_Tp_Oper = TPO.Cd_Tp_Oper
			Join LLP_Exp_Mar		LLP		With(Nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_Lem
Left outer	Join Tipo_Carga			TPC		With(Nolock) on LLP.Cd_Tp_Carga = TPC.Cd_Tp_Carga
Left Outer	Join Volume_Exp_Mar		VOL		With(Nolock) on HOU.Num_Proc_HEM = VOL.Num_Proc_HEM
left outer	Join Tipo_Embalagem		TE		With(Nolock) on	VOL.cd_tp_embal = TE.cd_tp_embal
Left Outer	Join Armador			ARM		With(Nolock) on LLP.Cd_Armador_Lem = ARM.Cd_Armador
Left Outer	Join Localidade			ORG		With(Nolock) on HOU.Cd_Org_Hem = ORG.Cd_Local
Left Outer	Join Localidade			DTF		With(Nolock) on LLP.Cd_DstFinal_Lem = DTF.Cd_Local
Left Outer	Join Tarefas_Processos	TT1		With(Nolock) on HOU.num_proc_hem=TT1.num_proc and TT1.ID_Task=1
Left Outer	Join Tarefas_Processos	TT4		With(Nolock) on HOU.num_proc_hem=TT4.num_proc and TT4.ID_Task=4
Left Outer	Join Tarefas_Processos	TT83	With(Nolock) on HOU.num_proc_hem=TT83.num_proc and TT83.ID_Task=83
Left Outer	Join Tarefas_Processos	TT66	With(Nolock) on HOU.num_proc_hem=TT66.num_proc and TT66.ID_Task=66
where 
	HOU.Num_Proc_HEM = @JOB
group by
	HOU.Num_Proc_HEM,
	HOU.HAWB_HEM,
	HOU.MAWB_HEM,
	JOB.Nr_Reserva,
	SHP.Apelido,
	CSN.Apelido,
	TPO.Nome_Tp_Oper,
	TPC.Nome_Tp_Carga,
	HOU.Navio_HEM,
	ARM.Nome_Armador,
	ORG.Nome_Local,
	DTF.Nome_Local,
	LLP.DL_Draft_Lem,
	LLP.DL_Cargo_Lem,
	LLP.ETD_Lem,
	LLP.ATD_Lem,
	TT1.Dt_Conclusao,
	TT4.Dt_Conclusao,
	HOU.TTime_d,
	TT83.Dt_Conclusao,
	TT66.Dt_Conclusao,
	VOL.QTD_VOL_EM,
	TE.nome_tp_embal

*/
GO
