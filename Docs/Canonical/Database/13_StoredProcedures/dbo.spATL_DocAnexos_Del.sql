SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spATL_DocAnexos_Del]

	@Num_Proc	VarChar(16),
	@Item_Doc 	int,
	@Nome_Doc	Varchar(25),
	@Nome_Arquivo Varchar(30),
	@Usuario	Varchar(30)

AS

BEGIN TRANSACTION

	Declare @Id_DC	int
	Declare @Cd_Usuario varchar(6)

	Set @Cd_Usuario = (select top 1 Cd_Usuario from Usuario where Nome_Usuario=@Usuario and Ck_Ativo='1')
	Set @Id_DC = (select Id_DC from Tipo_Doc_Cliente where nome_dc=@Nome_Doc)
	Set @Item_Doc = (select Item_Doc from Doc_Anexos where Num_Proc = @Num_Proc and Id_DC = @Id_DC)

	Delete Doc_Anexos where Num_Proc = @Num_Proc and Dt_Envio is null and Item_Doc = @Item_Doc and Id_DC = @Id_DC

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION







GO
