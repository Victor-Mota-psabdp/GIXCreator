SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Incluido o campo Planta - 03/08/09 - Rafael

CREATE	Procedure	[dbo].[spPlasticosClosed_T1_Rel] --'01-01-2008'
(
@Data datetime
)
As
select
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,3),P.Num_Pedido)  Order_Number,
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,1),P.Num_PO)		PO,
	HOU.Num_Proc_HIM														Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIM)										GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)									Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000									TON,
	LLP.Canal_LIM															Canal,
	sum(isnull(PD.Peso_Liquido_TOT,0))										Peso_Liquido,
	isnull(Peso_Bruto_him,0)												Peso_Bruto,
	sum(isnull(PD.Peso_Bruto_TOT,0))										Peso_Bruto_TOT,
	HOU.Navio_HIM															Navio,
	LC.Nome_Local															LocalChegada,
	LLP.ETD_LIM																ETD,
	LLP.ATD_LIM																DataEmbarque,
	LLP.ETA_LIM																ETA,
	ATA_LIM																	Atracacao,
	dbo.fBusca_Tarefa(hou.num_proc_him,'15')								PresencaCarga,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_him,54),ETA_Lim +13)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_him,57,getdate())						Entrega,
	dbo.fBusca_Historico(hou.num_proc_him,56,getdate())						Deposito,
	dbo.fBusca_Tarefa(hou.num_proc_him,13)									Data_PO,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate())				Motivo_Atraso,
	ARM.Nome_Armador														Transportador,
	AGT.Nome_Raz_Soc														Agente,
	dbo.FStatus_Plasticos(hou.num_proc_him,getdate())						Status,
	left(LLP.Num_Proc_LIM,2)												Modal,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2)												Company_ID,
	P.Planta,
	Peso_liquido_him
from
	House_Imp_Mar HOU
	Join LLP_Imp_Mar			LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Job_Imp_Mar		JIM	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Join Pedido_Ship 			PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		LC	on Hou.Cd_Dst_HIM = Lc.Cd_Local
	Left Join Armador			ARM	on JIM.Cd_Armador   = ARM.Cd_Armador
	Left Join Pessoa 			AGT	on JIM.cd_agente=AGT.cd_pes
	Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
where 
	convert(datetime,Dt_Emis_HIM,105) > @Data 
	--and 	(PO_GRP IN ('041','431'))
	and (P.Planta IN ('05031WQ','05031WJ'))
	and ((dbo.fBusca_Tarefa(hou.num_proc_him,13) <= getdate()-5) or (dbo.fBusca_Tarefa(hou.num_proc_him,13)is not null))
Group by
	HOU.Num_Proc_HIM,
	P.Num_Pedido,
	P.Num_PO,
	LLP.Num_Proc_LIM,
	LLP.Canal_LIM,
	HOU.Navio_HIM,
	LC.Nome_Local,
	LLP.PO_Req_Date, P.DL_Chegada,
	LLP.ATD_LIM,
	LLP.ETA_LIM,
	LLP.ATA_LIM,
	LLP.ATD_LIM,
	ARM.Nome_Armador,
	AGT.Nome_Raz_Soc,
	hou.peso_bruto_him,
	llp.etd_lim,
	PD.Peso_Bruto_TOT,
	PD.Cd_Pedido,
	PD.Cd_Produto,
	PD.Peso_Liquido_TOT,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2),
	P.Planta,
	Peso_liquido_him
UNION


select 
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,3),P.Num_Pedido)  Order_Number,
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,1),P.Num_PO)		PO,
	HOU.Num_Proc_hio														Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIO)										GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)									Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000									TON,
	LLP.Canal_lio															Canal,
	sum(isnull(PD.Peso_Liquido_TOT,0))										Peso_Liquido,
	isnull(Peso_Bruto_hio,0)												Peso_Bruto,
	sum(isnull(PD.Peso_Bruto_TOT,0))										Peso_Bruto_TOT,
	Null																	Navio,
	LC.Nome_Local															LocalChegada,
	LLP.ETD_lio																ETD,
	LLP.ATD_lio																DataEmbarque,
	LLP.ETA_lio																ETA,
	ATA_lio																	Atracacao,
	dbo.fBusca_Tarefa(hou.num_proc_hio,'15')								PresencaCarga,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hio,54),ETA_lio +13)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_hio,57,getdate())						Entrega,
	dbo.fBusca_Historico(hou.num_proc_hio,56,getdate())						Deposito,
	dbo.fBusca_Tarefa(hou.num_proc_hio,13)									Data_PO,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hio,54,getdate())				Motivo_Atraso,
	CAR.Nome_Raz_Soc														Transportador,
	AGT.Nome_Raz_Soc														Agente,
	dbo.FStatus_Plasticos(hou.num_proc_hio,getdate())						Status,
	LLP.Tipo_LIO															Modal,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2)												Company_ID,
	P.Planta,
	Peso_real_hio
from
	House_Imp_out HOU
	Join LLP_Imp_out			LLP	on HOU.Num_Proc_hio = LLP.Num_Proc_lio
	Join Pedido_Ship 			PS	on HOU.Num_Proc_hio = PS.Num_Proc
	Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Outer Join Localidade	LC	on Hou.Cd_Dst_hio = Lc.Cd_Local
	Left Outer Join Pessoa		CAR	on LLP.Cd_carrier   = CAR.Cd_Pes
	Left Outer Join Pessoa 		AGT	on LLP.cd_agente=AGT.cd_pes
	Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
where 
	convert(datetime,Dt_Emis_hio,105) > @Data 
	--and 	(PO_GRP IN ('041','431') )
	and (P.Planta IN ('05031WQ','05031WJ'))
	and ((dbo.fBusca_Tarefa(hou.num_proc_hio,13) <= getdate() -5) or (dbo.fBusca_Tarefa(hou.num_proc_hio,13)is not null))

Group by
	HOU.Num_Proc_hio,
	P.Num_Pedido,
	P.Num_PO,
	LLP.Canal_lio,
	LC.Nome_Local,
	LLP.PO_Req_Date, P.DL_Chegada,
	LLP.ATD_lio,
	LLP.ETA_lio,
	LLP.ATA_lio,
	LLP.ATD_lio,
	CAR.Nome_Raz_Soc,
	AGT.Nome_Raz_Soc,
	hou.peso_bruto_hio,
	llp.etd_lio,
	llp.tipo_lio,
	PD.Peso_Bruto_TOT,
	PD.Cd_Pedido,
	PD.Cd_Produto,
	Peso_Liquido_TOT,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2),
	P.Planta,
	Peso_real_hio

UNION

select 
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,3),P.Num_Pedido)  Order_Number,
	isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,1),P.Num_PO)		PO,
	HOU.Num_Proc_HIA														Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIA)										GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)									Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000									TON,
	LLP.Canal_LIA															Canal,
	sum(isnull(PD.Peso_Liquido_TOT,0))										Peso_Liquido,
	isnull(Peso_Bruto_hia,0)												Peso_Bruto,
	sum(isnull(PD.Peso_Bruto_TOT,0))										Peso_Bruto_TOT,
	Null																	Navio,
	LC.Nome_Local															LocalChegada,
	LLP.ETD_LIA																ETD,
	LLP.ATD_LIA																DataEmbarque,
	LLP.ETA_LIA																ETA,
	LLP.ATA_LIA																Atracacao,
	dbo.fBusca_Tarefa(hou.num_proc_hia,'15')								PresencaCarga,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_HIA,54),ETA_LIA +13)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_hia,57,getdate())						Entrega,
	dbo.fBusca_Historico(hou.num_proc_hia,56,getdate())						Deposito,
	dbo.fBusca_Tarefa(hou.num_proc_hia,13)									Data_PO,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,54,getdate())				Motivo_Atraso,
	CIA.Nome_Cia_Aer														Transportador,
	AGT.Nome_Raz_Soc														Agente,
	dbo.FStatus_Plasticos(hou.num_proc_HIA,getdate())						Status,
	Left(LLP.Num_Proc_LIA,2)												Modal,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2)												Company_ID,
	P.Planta,
	Peso_real_hia
from
	House_Imp_Aer 			HOU
	Join LLP_Imp_Aer			LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Outer Join Job_Imp_Aer	JIA	on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
	Join Pedido_Ship 			PS	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Outer Join Localidade	LC	on Hou.Cd_Dst_HIA = Lc.Cd_Local
	Left Outer Join Cia_Aerea	CIA	on JIA.Cd_Cia_Aer   = CIA.Cd_Cia_Aer
	Left Join Pessoa 			AGT	on JIA.cd_agente=AGT.cd_pes
	Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
where 
	convert(datetime,Dt_Emis_HIA,105) > @Data 
		and (P.Planta IN ('05031WQ','05031WJ'))
		--and (PO_GRP IN ('041','431') )
		and ((dbo.fBusca_Tarefa(hou.num_proc_hia,13) <= getdate() -5) or (dbo.fBusca_Tarefa(hou.num_proc_hia,13)is not null))
Group by
	HOU.Num_Proc_HIA,
	P.Num_Pedido,
	P.Num_PO,
	LLP.Num_Proc_LIA,
	LLP.Canal_LIA,
	LC.Nome_Local,
	LLP.PO_Req_Date, P.DL_Chegada,
	LLP.ATD_LIA,
	LLP.ETA_LIA,
	LLP.ATA_LIA,
	LLP.ATD_LIA,
	CIA.Nome_Cia_Aer,
	AGT.Nome_Raz_Soc,
	hou.peso_bruto_HIA,
	LLP.ETD_LIA,
	PD.Peso_Bruto_TOT,
	PD.Cd_Pedido,
	PD.Cd_Produto,
	Peso_Liquido_TOT,
	PD.Peso_UOM,
	Right(Left(P.Planta,5),2),
	P.Planta,
	Peso_real_hia

order by
	Status , Processo


GO
