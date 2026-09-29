SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spINTSmartPagamentos_Sel]
		@Num_Proc	Varchar(16),
		@Nome_Tp_Tx	Varchar(50)
		
AS

select  
	top 1 convert(Datetime,dt_pgto_Rcto_hia,105) Data,
	'BR'+ref_Ctb_tx Code

from 
	vwcxas CXA with(nolock)
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_Tx
Where
	nome_tp_tx like @Nome_Tp_Tx
	and dc_hia='D'
	
	
	

GO
