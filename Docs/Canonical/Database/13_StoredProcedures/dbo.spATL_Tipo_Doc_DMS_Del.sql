SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Doc_DMS
CREATE procedure [dbo].[spATL_Tipo_Doc_DMS_Del]
(
	@DMS_Code varchar(5)
)
as
	UPDATE Tipo_Doc_DMS SET ATIVO= 0 where DMS_Code= @DMS_Code

GO
