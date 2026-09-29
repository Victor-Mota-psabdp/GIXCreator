SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Site
CREATE procedure [dbo].[spATLDN_Site_Del]
(
	@Cd_Site		char(1)
)
as
	UPDATE Site SET Status= 0 where Cd_Site= @Cd_Site

GO
