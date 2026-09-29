SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HEM
CREATE procedure [dbo].[spATL_PO_HEM_Del]
(
	@Num_Proc_HEM	varChar(16),
	@ID_PO_HEM		int
)

as
	 if exists(select PO.Num_Proc_HEM from PO_HEM PO with(nolock) where PO.Num_Proc_HEM = @Num_Proc_HEM and PO.ID_PO_HEM = @ID_PO_HEM)
		Begin
			delete PO_HEM where Num_Proc_HEM = @Num_Proc_HEM and ID_PO_HEM = @ID_PO_HEM
		End

GO
