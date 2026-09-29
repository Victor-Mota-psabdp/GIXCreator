SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Base_Nota_Fiscal_QR_Code
CREATE procedure [dbo].[spATL_Base_Nota_Fiscal_QR_Code_Del]
(
	@ID				int,
	@Nota_Fiscal	varchar(30),
	@Ref_Acesso		varchar(30)
)
as
	UPDATE Base_Nota_Fiscal_QR_Code set status = 0 where ID	= @ID	

GO
