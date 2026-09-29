SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ATL_INT_LayoutField_Template_Sel]
(
    @CodUser    varchar(20)
)
AS


Select a.ID, a.PK_Code, a.Name From ATL_INT.DBO.LayoutField_Template a 
Order by a.PK_Code asc

GO
