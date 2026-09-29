SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[spTelaLabels_InsUpd]

	@cd_tela	varchar(3),
	@lblATL		int,
	@Descr_ING	varchar(50)

AS

Begin Transaction

	declare @ID_ATL_Labels int
	set @ID_ATL_Labels = (select ID from ATL_Labels where Descr_ING=@Descr_ING)

	IF  exists( select * from Tela_Labels where cd_tela=@cd_tela and lblATL=@lblATL)
		BEGIN
			UPDATE
				Tela_Labels
			SET
				ID_ATL_Labels = @ID_ATL_Labels
			WHERE
				cd_tela=@cd_tela and lblATL=@lblATL
		END
	ELSE
		INSERT
			Tela_Labels(
				cd_tela, lblATL, ID_ATL_Labels
				)
		Values
			(
				@cd_tela, @lblATL,@ID_ATL_Labels
			)

Commit Transaction


GO
