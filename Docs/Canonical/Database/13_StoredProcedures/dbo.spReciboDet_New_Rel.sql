SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReciboDet_New_Rel]

		@ID bigint 
		
AS

select 
	ID,
	ID_Item,
	TT.Nome_Tp_Tx [nome_taxa],
	DC,
	Cd_Tp_Moeda [Tp_moeda],
	Vlr_Ref,
	Par_Moeda,
	Vlr_Ref_Total
from Recibo_Item RI with(nolock)
	Join Tipo_Taxa TT with(nolock) on RI.Cd_Tp_Tx = TT.Cd_Tp_Tx
 where
	RI.ID = @ID
GO
