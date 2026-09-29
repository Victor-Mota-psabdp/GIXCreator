SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Doc_RF
CREATE procedure [dbo].[spATL_Tipo_Doc_RF_Del]
(
	@Cd_Tipo_Doc_RF varchar(1)
)
as
	if exists(select Cd_Tipo_Doc_RF from Tipo_Doc_RF where Cd_Tipo_Doc_RF= @Cd_Tipo_Doc_RF) 
	begin
		UPDATE Tipo_Doc_RF SET Ativo = 'N' where Cd_Tipo_Doc_RF= @Cd_Tipo_Doc_RF
	end

GO
