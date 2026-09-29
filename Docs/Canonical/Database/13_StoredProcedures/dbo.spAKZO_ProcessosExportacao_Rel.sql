SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--11-06-2008
--Week 24
--Inicio Relatório AKZO Exportação
--Parametros: 'O' Ocean	-	'T' Truck	- 'C' Container

CREATE Procedure [dbo].[spAKZO_ProcessosExportacao_Rel] --'C'
(
@Modal	char(1)
)
as

	If @Modal = 'O' 
		Select
			PO.Data_PO_HEM		Data_Ordem,
			HOU.Num_Proc_HEM	Ref_BDP,
			PO.Numero_PO_HEM	Ref_AKZO,
			INV.Numero_PO_HEM	Fatura,
			CONS.Nome_Raz_Soc	Cliente,
			DEST.Pais_Local		Pais_Destino,
			SO.Numero_PO_HEM	Ordem_Cliente,
			SO.Data_PO_HEM		Solicitado,
			null				Data_Programacao,
			null				Carregamento,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,1)	Solic_BKG,
			JOB.Nr_Reserva		Booking,
			HOU.Navio_HEM		Navio,
			null				DeadLine,
			LLP.ETD_LEM			ETD,
			LLP.ETA_LEM			ETA,
			null				Aprov_DCA,
			ARM.Nome_Armador	Transportadora,
			null				Programado_P,
			null				Veiculo,
			null				Progr_Agendamento,
			null				Local_Entrega_Carga,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,12)	Envio_Docs,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4)	Desembaraco,
			dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HEM,0,getdate()) Status,
			null				Env_BDP_Faturar,
			'Itupeva'			Faturar_para
		from
			House_Exp_Mar HOU
			Join LLP_Exp_Mar	LLP		on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
			Left Join Job_Exp_Mar JOB	on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
			Left Join Armador 	ARM		on LLP.Cd_Armador_LEM = ARM.cd_armador
			Left Join Pessoa	CONS	on HOU.cd_consig_HEM = CONS.cd_pes
		--	Left Join Pessoa	EXPO	on HOU.cd_export_hem = EXPO.cd_pes
			Left Join Localidade DEST	on HOU.Cd_Dst_HEM = DEST.Cd_Local
			Left Join PO_HEM	PO		on HOU.Num_Proc_HEM = PO.Num_Proc_HEM and PO.ID_DC = 1
			Left Join PO_HEM	INV		on HOU.Num_Proc_HEM = INV.Num_Proc_HEM and INV.ID_DC = 2
			Left Join PO_HEM	SO		on HOU.Num_Proc_HEM = SO.Num_Proc_HEM and SO.ID_DC = 3
			Join Pessoa_LLP		PLLP	on PLLP.Cd_Pes=HOU.Cd_Export_HEM and PLLP.Cd_Pes_Grupo = '10'

Else
	If @Modal =  'T'
		Select
			PO.Data_PO_HEO		Data_Ordem,
			HOU.Num_Proc_HEO	Ref_BDP,
			PO.Numero_PO_HEO	Ref_AKZO,
			INV.Numero_PO_HEO	Fatura,
			CONS.Nome_Raz_Soc	Cliente,
			DEST.Pais_Local		Pais_Destino,
			SO.Numero_PO_HEO	Ordem_Cliente,
			SO.Data_PO_HEO		Solicitado,
			null				Data_Programacao,
			null				Carregamento_Entrega,
			CARR.Nome_Raz_Soc	Transportadora,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,10)	Saida,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,12)	Envio_Docs,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4)	Desembaraco,
			dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HEO,0,getdate()) Status,
			null				Env_BDP_Faturar,
			'Itupeva'			Faturar_para
		from
			House_Exp_Out HOU
			Join LLP_Exp_Out	LLP		on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
			Left Join Pessoa	CARR	on LLP.cd_carrier = CARR.cd_pes
			Left Join Pessoa	CONS	on HOU.cd_consig_HEO = CONS.cd_pes
		--	Left Join Pessoa	EXPO	on HOU.cd_export_heo = EXPO.cd_pes
			Left Join Localidade DEST	on HOU.Cd_Dst_HEO = DEST.Cd_Local
			Left Join PO_HEO	PO		on HOU.Num_Proc_HEO = PO.Num_Proc_HEO and PO.ID_DC = 1
			Left Join PO_HEO	INV		on HOU.Num_Proc_HEO = INV.Num_Proc_HEO and INV.ID_DC = 2
			Left Join PO_HEO	SO		on HOU.Num_Proc_HEO = SO.Num_Proc_HEO and SO.ID_DC = 3
			Join Pessoa_LLP		PLLP	on PLLP.Cd_Pes=HOU.Cd_Export_HEO and PLLP.Cd_Pes_Grupo = '10'

Else
	If @Modal = 'C' 
		Select
			null				Data_Devolucao,
			HOU.Num_Proc_HEM	Ref_BDP,
			PO.Numero_PO_HEM	Ref_AKZO,
			Nome_Tp_cont		Equipamento,
			Num_cont_EM			Numero,
			Num_lacre_EM		Lacre,
			null				Produto,
			null				Programacao,
			null				Data_Retirada,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,1)	Solic_BKG,
			JOB.Nr_Reserva		Booking,
			HOU.Navio_HEM		Navio,
			null				DeadLine,
			LLP.ETD_LEM			ETD,
			LLP.ETA_LEM			ETA,
			dbo.fBusca_HistoricoDescr(HOU.Num_Proc_HEM,0,getdate()) Status,
			null				Env_BDP_Faturar,
			'Itupeva'			Faturar_para
		from
			House_Exp_Mar HOU
			Join LLP_Exp_Mar				LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
			Left Join Job_Exp_Mar			JOB	on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
			Left Join PO_HEM				PO	on HOU.Num_Proc_HEM = PO.Num_Proc_HEM and PO.ID_DC = 1
			Left Join Container_Hou_Exp_Mar CON on HOU.Num_Proc_HEM = CON.Num_Proc_HEM 
			Left Join container_mas_exp_mar MAS on MAS.Num_Proc_MEM = CON.Num_Proc_MEM and MAS.Item_Cont_EM = CON.Item_Cont_EM   
			Left Join Tipo_Container		TC	on TC.cd_tp_cont=MAS.cd_tp_cont
			Join Pessoa_LLP					PLLP on PLLP.Cd_Pes=HOU.Cd_Export_HEM and PLLP.Cd_Pes_Grupo = '10'
Else
	select
	null Aprov_DCA,null Booking,null Carregamento,null Carregamento_Entrega,null Cliente,null Data_Devolucao,
	null Data_Ordem,null Data_Programacao,null Data_Retirada,null DeadLine,null Desembaraco,null Env_BDP_Faturar,
	null Envio_Docs,null Equipamento,null ETA,null ETD,null Fatura,null Faturar_para,null Lacre,null Local_Entrega_Carga,
	null Navio,null Numero,null Ordem_Cliente,null Pais_Destino,null Produto,null Progr_Agendamento,null Programacao,
	null Programado_P,null Ref_AKZO,null Ref_BDP,null Saida,null Solic_BKG,null Solicitado,null Status,null Transportadora,null Veiculo

GO
