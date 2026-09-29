SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[spTelaLabels_Del]

	@cd_tela	varchar(3),
	@lblATL		int,
	@Descr_ING	varchar(50)

AS

Begin Transaction

	declare @ID_ATL_Labels int
	set @ID_ATL_Labels = (select ID from ATL_Labels where Descr_ING=@Descr_ING)

		BEGIN
			DELETE
				Tela_Labels
			WHERE
				cd_tela=@cd_tela and lblATL=@lblATL and ID_ATL_Labels = @ID_ATL_Labels
		END

Commit Transaction


GO
