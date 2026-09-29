SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[spATL_GNC_EXP_Rel] -- exec spATL_GNC_EXP_Rel 'GRUPO ALL','2023-05-01','2023-05-22'

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
As


		select 
		--PG.Apelido									[GRUPO],
		HG.Dt_Emis										[DT. REGISTRO],
		HG.Modal										[MODAL],
		HSGProcesso										[BDP REF.],
		CE.Nome_Raz_Soc									[SHIPPER],
		case 
		WHEN len(CE.Num_CPF_CNPJ)>14 then substring(CE.Num_CPF_CNPJ,2,2) + '.' + substring(CE.Num_CPF_CNPJ,4,3) + '.' + substring(CE.Num_CPF_CNPJ,7,3) + '/' + substring(CE.Num_CPF_CNPJ,10,4) + '-' + substring(CE.Num_CPF_CNPJ,14,2)    
		ELSE  substring(CE.Num_CPF_CNPj,1,2) + '.' + substring(CE.Num_CPF_CNPj,3,3) + '.' + substring(CE.Num_CPF_CNPj,6,3) + '/' + substring(CE.Num_CPF_CNPj,9,4) + '-' + substring(CE.Num_CPF_CNPj,13,2)    End [CNPJ],
		[dbo].[fBusca_Docs_PO_Master](HG.Num_Proc,'3')	[SALES ORDER],
		[dbo].[fBusca_Docs_PO_Master](HG.Num_Proc,'9')	[CUSTOMER PO],
		[dbo].[fBusca_Docs_PO_Master](HG.Num_Proc,'8')	[SHIPMENT NUMBER],
		tc.Nome_Tp_Carga								[TYPE OF CARGO],
		HG.Booking_Number								[N. BOOKING],
		HG.Cd_Armador									[CARRIER],
		HG.HAWB											[HOUSE],
		TP223.Dt_Conclusao								[DT. CARREGAMENTO],
		cast(dbo.fBusca_TipoDocCliente('D',HG.Num_Proc,10) as datetime)[DT. NF],
		dbo.fBusca_Docs_PO_Modal(HG.Num_Proc,'10')		[N. NF],
		T.Nome_Terminal									[TERMINAL],
		dbo.fBusca_Docs_PO_Modal(HG.Num_Proc,'204')		[N. DUE],
		dbo.fBusca_DATA_PO_Modal(HG.Num_Proc,'204')		[REGISTRO DUE],
		HG.Canal										[CHANNEL],
		T4.Dt_Conclusao									[DATA DE DESEMBARAÇO],
		Trucker.Nome_Raz_Soc							[INLAND TRUCKER],
		HG.ETD											[ETD DATE],
		HG.ATD											[ATD DATE],

		DATEDIFF(day,HG.ETD,HG.ATD)						[DIF. DATAS],
		(Case when hg.Cd_Tp_Carga = '1' and DATEDIFF(day,HG.ETD,HG.ATD) > 8 then 'LATE' else
		(Case when hg.Cd_Tp_Carga = '1' and DATEDIFF(day,HG.ETD,HG.ATD) <= 8 then 'ON TIME' else    
		(Case when hg.Cd_Tp_Carga = '2' and DATEDIFF(day,HG.ETD,HG.ATD) > 10 then 'LATE' else 
		(Case when hg.Cd_Tp_Carga = '2' and DATEDIFF(day,HG.ETD,HG.ATD) <= 10 then 'ON TIME' else
		(Case when hg.Cd_Tp_Carga = '3' and DATEDIFF(day,HG.ETD,HG.ATD) > 5 then 'LATE' else
		(Case when hg.Cd_Tp_Carga = '3' and DATEDIFF(day,HG.ETD,HG.ATD) < 5 then 'ON TIME' else 
		
		(Case when hg.Modal = 'Air Export' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 5 then 'LATE' else 
		(Case when hg.Modal = 'Air Export' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 5 then 'ON TIME' else

		(Case when hg.Modal = 'Other Export' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 7 then 'LATE' else
		(Case when hg.Modal = 'Other Export' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 7 then 'ON TIME' End) End) End) End) End) End) End) End) End) End) [DELAY],

		HGI.HSGData										[REGISTRO GNC],
		TPNC.Cd_NC										[GNC CODE],
		TPNC.Parte_Resp									[RESP. PART],
		TPNC.Descricao_nC								[NC DESC],
		TPNC.Descricao_NC_ENG							[NC DESC ENG],
		TPNC.Descricao_NC_PTG							[NC DESC PTG],
		hgi.hsddescricao								[HISTORICO GNC],
		HGI.HSGDataFU									[DT. PREVISAO],
		HGI.Disp_Cliente								[VISIVEL P/ CLIENTE]
		
	
	from
		vwHouse_Exp					HG		with(nolock)
		join Pessoa					CE		with(nolock) on CE.cd_pes		=	HG.Cd_Export
		--Join Pessoa					Shipper with(nolock) on Shipper.cD_pes=cd_export
		Join Pessoa_LLP				PLL		with(nolock) on PLL.Cd_Pes		=	HG.Cd_Export
		join Grupo					G		with(nolock) on G.cd_pes_grupo	=	PLL.cd_pes_grupo
		join Hist_Geral				HGI		with(nolock) on HG.Num_Proc		=	HGI.HSGProcesso
		INNER join Pessoa			PG		with(nolock) on PG.cd_pes		=	PLL.Cd_Pes_Grupo
		left join Tipo_Carga		TC		with(nolock) on TC.Cd_Tp_Carga	=	HG.Cd_Tp_Carga
		Left Join Tarefas_processos	T7		with(nolock) on HG.Num_Proc		=	T7.Num_proc and T7.ID_Task = 7
		Left Join Tarefas_processos	T4		with(nolock) on HG.Num_Proc		=	T4.Num_proc and T4.ID_Task = 4
		--Left Outer Join Tarefas_processos	T198	on HG.Num_Proc = T198.Num_proc and T198.ID_Task = 198
		Left Join Tarefas_processos TP223	with(nolock) on HG.Num_Proc		=	TP223.Num_Proc and TP223.ID_Task=223		
		Join Tipo_NC_Cliente		TPNC	with(nolock) on TPNC.Cd_NC		=	HGI.ID_NC
		Left Join Pessoa			Trucker with(nolock) on HG.Cd_Transportadora	=	Trucker.cd_pes
		Left Join Terminal			T		with(nolock) on T.Cd_Terminal	=	HG.Cd_Terminal
		
		--left join Pedido_Ship PS with(nolock) on HG.Num_Proc = PS.Num_Proc    
		--left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
	where
		HGI.HSGData between @DtInicial and @DtFinal
		and 
		(PG.Apelido like @Grupo or @Grupo ='Grupo ALL')

GO
