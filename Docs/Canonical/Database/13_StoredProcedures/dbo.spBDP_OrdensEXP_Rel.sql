SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create	Procedure	[dbo].[spBDP_OrdensEXP_Rel]
(
@Grupo as varchar(3)
)
As
	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select Cd_Pes_Grupo from Grupo where Grupo=@Grupo)

	Select
		HOU.Num_Proc_HEM										BDP_Reference,
		dbo.FStatus_Plasticos(hou.num_proc_HEM,getdate())		Status,
		Right(Left(PLA.Cd_Planta,5),2)							Company_ID,
		P.Num_Pedido											Ordem,
		PLA.Cd_Planta											Planta,
		isnull(PO.Numero_PO_HEM,P.Num_PO)						PU,
		dbo.fBusca_GMID(HOU.Num_Proc_HEM)						GMIDs,
		CNS.Apelido												Consignee,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEM)					Produtos,
		sum(isnull(PD.Peso_Liquido_TOT,0))						Peso_Liquido,
		LLP.ATD_LEM												ATD,
		LLP.ETD_LEM												ETD,
		LLP.ETA_LEM												ETA,
		LLP.ATA_LEM												ATA,
		Isnull(dbo.fBusca_Historico(hou.num_proc_HEM,54,getdate()),ETA_LEM +7) Previsao,
		P.Incoterm,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HEM,54,getdate()) Motivo_Atraso,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,13)					Entrega,
		Cidade,
		Nome_Local												Destino,
		Nome_Usuario,
		TF.Dt_Conclusao											GI,
		TF.Dt_Previsao											PGI,
		Job.Dead_line,
		GRE.Dt_Conclusao										Entrega_Planta	
	from
		House_EXP_MAR HOU
		Join LLP_EXP_MAR	LLP	on HOU.Num_Proc_HEM =LLP.Num_Proc_LEM
		Join Pedido_Ship	PS	on HOU.Num_Proc_HEM =PS.Num_Proc
		Join Pedido_Det 	PD	on PD.cd_pedido		=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Join Pedido			P	on PS.Cd_Pedido		=P.Cd_Pedido
		Join Pessoa_LLP		PLA	on HOU.cd_export_HEM=PLA.cd_pes
		Join Pessoa			CNS	on HOU.cd_consig_HEM=CNS.cd_pes
		Left Join PO_HEM	PO	on HOU.Num_Proc_HEM =PO.Num_Proc_HEM and id_dc=1
		Left Join Endereco	ED	on CNS.cd_pes=ED.cd_pes and cd_tp_end='COM'
		Join Localidade		DST on DST.cd_local=cd_dst_hem
		Join Usuario_Cliente	CSR on CSR.cd_usuario=cd_csrid
		Join Tarefas_Processos TF on TF.num_proc=num_proc_lem and TF.ID_Task=10 --and cd_pes_grupo='1'
		Join Job_exp_mar Job on job.num_proc_hem=num_proc_lem
		Join Tarefas_Processos GRE on GRE.num_proc=num_proc_lem and GRE.ID_Task=13 --and GRE.cd_pes_grupo='1'
		Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo=@Cd_Grupo
	where
		(ata_lem is null or ata_lem <=getdate()+15)
	group by
		HOU.Num_Proc_HEM,
		Right(Left(PLA.Cd_Planta,5),2),
		P.Num_Pedido,
		PLA.Cd_Planta,
		PO.Numero_PO_HEM,
		P.Num_PO,
		CNS.Apelido,
		PD.Peso_Liquido_TOT,
		LLP.ATD_LEM,
		LLP.ETD_LEM,
		LLP.ETA_LEM,
		LLP.ATA_LEM,
		P.Incoterm,
		Cidade,
		Nome_Local,
		Nome_Usuario,
		TF.Dt_Conclusao,
		TF.Dt_Previsao,
		Job.Dead_line,
		GRE.Dt_Conclusao

	UNION
	Select
		HOU.Num_Proc_HEA										BDP_Reference,
		dbo.FStatus_Plasticos(hou.num_proc_HEA,getdate())		Status,
		Right(Left(PLA.Cd_Planta,5),2)							Company_ID,
		P.Num_Pedido											Ordem,
		PLA.Cd_Planta											Planta,
		isnull(PO.Numero_PO_HEA,P.Num_PO)						PU,
		dbo.fBusca_GMID(HOU.Num_Proc_HEA)						GMIDs,
		CNS.Apelido												Consignee,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEA)					Produtos,
		sum(isnull(PD.Peso_Liquido_TOT,0))						Peso_Liquido,
		LLP.ATD_LEA												ATD,
		LLP.ETD_LEA												ETD,
		LLP.ETA_LEA												ETA,
		LLP.ATA_LEA												ATA,
		Isnull(dbo.fBusca_Historico(hou.num_proc_HEA,54,getdate()),ETA_LEA +7) Previsao,
		P.Incoterm,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HEA,54,getdate()) Motivo_Atraso,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,13)					Entrega,
		Cidade,
		Nome_Local												Destino,
		Nome_Usuario,
		TF.Dt_Conclusao,
		TF.Dt_Previsao,
		null,
		GRE.Dt_Conclusao
	from
		House_EXP_AER HOU
		Join LLP_EXP_AER	LLP	on HOU.Num_Proc_HEA =LLP.Num_Proc_LEA
		Join Pedido_Ship	PS	on HOU.Num_Proc_HEA =PS.Num_Proc
		Join Pedido_Det 	PD	on PD.cd_pedido		=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Join Pedido			P	on PS.Cd_Pedido		=P.Cd_Pedido
		Join Pessoa_LLP		PLA	on HOU.cd_export_HEA=PLA.cd_pes
		Join Pessoa			CNS	on HOU.cd_consig_HEA=CNS.cd_pes
		Left Join PO_HEA	PO	on HOU.Num_Proc_HEA =PO.Num_Proc_HEA and id_dc=1
		Left Join Endereco	ED	on CNS.cd_pes=ED.cd_pes and cd_tp_end='COM'
		Join Localidade DST on DST.cd_local=cd_dst_hea
		Join Usuario_Cliente	CSR on CSR.cd_usuario=cd_csrid
		Join Tarefas_Processos TF on TF.num_proc=num_proc_lea and TF.ID_Task=10 
		Join Tarefas_Processos GRE on GRE.num_proc=num_proc_lea and GRE.ID_Task=13 
		Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo=@Cd_Grupo
	where
		(ata_lea is null or ata_lea <=getdate()+15)
	group by
		HOU.Num_Proc_HEA,
		Right(Left(PLA.Cd_Planta,5),2),
		P.Num_Pedido,
		PLA.Cd_Planta,
		PO.Numero_PO_HEA,
		P.Num_PO,
		CNS.Apelido,
		PD.Peso_Liquido_TOT,
		LLP.ATD_LEA,
		LLP.ETD_LEA,
		LLP.ETA_LEA,
		LLP.ATA_LEA,
		P.Incoterm,
		Cidade,
		Nome_Local,
		Nome_usuario,
		TF.Dt_Conclusao,
		TF.Dt_Previsao,
	GRE.Dt_Conclusao

	UNION
	Select
		HOU.Num_Proc_HEO										BDP_Reference,
		dbo.FStatus_Plasticos(hou.num_proc_HEO,getdate())		Status,
		Right(Left(PLA.Cd_Planta,5),2)							Company_ID,
		P.Num_Pedido											Ordem,
		PLA.Cd_Planta											Planta,
		isnull(PO.Numero_PO_HEO,P.Num_PO)						PU,
		dbo.fBusca_GMID(HOU.Num_Proc_HEO)						GMIDs,
		CNS.Apelido												Consignee,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEO)					Produtos,
		sum(isnull(PD.Peso_Liquido_TOT,0))						Peso_Liquido,
		CCD.Dt_Conclusao											ATD,
		LLP.ETD_LEO												ETD,
		LLP.ETA_LEO												ETA,
		CCD.Dt_Conclusao										ATA,
		Isnull(dbo.fBusca_Historico(hou.num_proc_HEO,54,getdate()),ETA_LEO +7) Previsao,
		P.Incoterm,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HEO,54,getdate()) Motivo_Atraso,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,13)					Entrega,
		Cidade,
		Nome_Local												Destino,
		Nome_Usuario											CSR_Name,
		TF.Dt_Conclusao,
		TF.Dt_Previsao,
		Null,
		GRE.Dt_Conclusao
	from
		House_EXP_OUT HOU
		Join LLP_EXP_OUT	LLP	on HOU.Num_Proc_HEO =LLP.Num_Proc_LEO
		Join Pedido_Ship	PS	on HOU.Num_Proc_HEO =PS.Num_Proc
		Join Pedido_Det 	PD	on PD.cd_pedido		=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Join Pedido			P	on PS.Cd_Pedido		=P.Cd_Pedido
		Join Pessoa_LLP		PLA	on HOU.cd_export_HEO=PLA.cd_pes
		Join Pessoa			CNS	on HOU.cd_consig_HEO=CNS.cd_pes
		Left Join PO_HEO	PO	on HOU.Num_Proc_HEO =PO.Num_Proc_HEO and id_dc=1
		Left Join Endereco	ED	on CNS.cd_pes=ED.cd_pes and cd_tp_end='COM'
		Join Localidade		DST	on DST.cd_local=cd_dst_heo
		Join Usuario_Cliente CSR on CSR.cd_usuario=cd_csrid
		Join Tarefas_Processos TF on TF.num_proc=num_proc_leo and TF.ID_Task=10 --and TF.cd_pes_grupo='1'	
		Join Tarefas_Processos CCD on CCD.num_proc=num_proc_leo and CCD.ID_Task=4 --and CCD.cd_pes_grupo='1'
		Join Tarefas_Processos GRE on GRE.num_proc=num_proc_leo and GRE.ID_Task=13 --and GRE.cd_pes_grupo='1'
		Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo=@Cd_Grupo
	where
		(ata_leo is null or ata_leo >= getdate()-15)
	group by
		HOU.Num_Proc_HEO,
		Right(Left(PLA.Cd_Planta,5),2),
		P.Num_Pedido,
		PLA.Cd_Planta,
		PO.Numero_PO_HEO,
		P.Num_PO,
		CNS.Apelido,
		PD.Peso_Liquido_TOT,
		LLP.ATD_LEO,
		LLP.ETD_LEO,
		LLP.ETA_LEO,
		LLP.ATA_LEO,
		P.Incoterm,
		Cidade,
		Nome_local,
		Nome_Usuario,
		TF.Dt_Conclusao,
		TF.Dt_Previsao,
		CCD.Dt_Conclusao,
		GRE.Dt_Conclusao







GO
