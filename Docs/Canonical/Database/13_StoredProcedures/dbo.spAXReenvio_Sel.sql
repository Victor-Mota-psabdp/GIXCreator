SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spAXReenvio_Sel]
AS
/*
select AXI.DC,AXI.ID_AX,Moeda,Tipo,AXI.Cd_tp_TX_ATL,AXI.num_proc from ax_doc AX
Join Ax_doc_item axi on ax.id_Ax=AXI.id_Ax
Left Join Ax_Doc_xml AXX on AXX.id_Ax=AXI.id_ax and AXX.num_proc=AXI.num_proc and  AXX.cd_Tp_tx_aTL=AXI.cd_tp_Tx_ATL and AXX.dc=AXI.dc
where dt_envio_Ax is not null
and AXX.id_Ax is null and axi.cd_tp_Tx is not null and cd_pessoa_ax is not null and AXI.cd_tp_Tx <> '000.1'
*/
--and dt_ins between '12-01-2013' and '12-31-2013'
GO
