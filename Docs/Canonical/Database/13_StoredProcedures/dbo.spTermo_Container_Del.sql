SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Termo_Container
CREATE  procedure [dbo].[spTermo_Container_Del](
	@cd_termo	int
)
as
	delete Termo_Container where cd_termo= @cd_termo

GO
