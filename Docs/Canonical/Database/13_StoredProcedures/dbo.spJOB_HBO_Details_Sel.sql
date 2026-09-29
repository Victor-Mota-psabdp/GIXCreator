SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spJOB_HBO_Details_Sel]
(
	@num_proc	VarChar(16)
)
AS
	
	Select 
	'' Shipper, 
	Consig.Apelido Consignee,
	dbo.fBusca_Docs_PO_Modal(v.Num_Proc,1) PO,
	dbo.fBusca_Docs_PO_Modal(v.Num_Proc,9) Shipment,
	V.HAWB,
	B.Nome_BDP_Produto BDPProduct	
From 
	vwCliente_Alerta V	
	Left Join Pessoa Consig  on v.cd_cliente  = Consig.Cd_Pes
	Left join BDP_Produto B on B.ID_PD = [dbo].[fBusca_CampoCliente](v.Num_Proc,143)	
Where 
	v.Num_Proc = @num_proc

	
GO
