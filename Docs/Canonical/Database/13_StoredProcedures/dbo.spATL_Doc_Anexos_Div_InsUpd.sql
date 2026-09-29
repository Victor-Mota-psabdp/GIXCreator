SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Doc_Anexos_Div_InsUpd]
(

	@Cd_Prod		varchar(10),
	@Item_Doc		int,
	@ID_Tipo_Doc	int,	
	@Nome_Doc		varchar(25),
	@Nome_Arquivo	varchar(100),
	@Dt_Anexo		Datetime,
	@Usuario		Varchar(30),
	@Dt_Venc		Datetime
)

AS

BEGIN TRANSACTION

	Declare @Id_Doc	int
	Declare @Cd_Usuario varchar(6)

	Set @Cd_Usuario = (select top 1 Cd_Usuario from Usuario where Nome_Usuario=@Usuario and Ck_Ativo='1')
	Set @Id_Doc = (select Id_DC from Tipo_Doc_Cliente where nome_dc=@Nome_Doc)
	Set @Item_Doc = (select Item_Doc from Doc_Anexos_Div where Cd_Prod = @Cd_Prod and Id_Doc = @Id_Doc)
	
	if @Item_Doc is not null 
		begin
			update
				Doc_Anexos_Div
			set
				Id_Doc = @Id_Doc,
				Nome_Arquivo = @Nome_Arquivo,
				--Dt_Anexo = GETDATE(),
				cd_Usuario = @cd_Usuario,
				Dt_Venc = @Dt_Venc
			where
				item_Doc = @Item_Doc and Id_Tipo_Doc = @ID_Tipo_Doc and Id_Doc = @Id_Doc and cd_Prod = @Cd_Prod
		end
	else
		begin
			SET @Item_Doc=(select Isnull(max(Item_Doc),0)+1 from Doc_Anexos_Div where cd_Prod = @Cd_Prod)
			Insert Into
					Doc_Anexos_Div
					(Item_Doc,
					 Id_Tipo_Doc,
					 Id_Doc,
					 Cd_Prod,
					 Nome_Arquivo,
					 Dt_Anexo,
					 Cd_Usuario,
					 Dt_Venc)
			values
					(@Item_Doc,
					 @ID_Tipo_Doc,
					 @Id_Doc,
					 @Cd_Prod,
					 @Nome_Arquivo,
					 GETDATE(),
					 @Cd_Usuario,
					 @Dt_Venc)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION

GO
