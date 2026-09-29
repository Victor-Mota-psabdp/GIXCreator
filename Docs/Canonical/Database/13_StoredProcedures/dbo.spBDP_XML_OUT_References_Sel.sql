SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBDP_XML_OUT_References_Sel]
(
	@Num_Proc	Varchar(16),
	@id_dc		int

)
as

	Select
		Numero_PO [ReferenceNumber],
		Data_PO   [Data],
		Data_PO   [StatusDate]	
	from 
		vwPO_ALL PP with(nolock)
	Where  
		pp.Num_Proc =@Num_Proc and pp.ID_DC =@id_dc 
GO
