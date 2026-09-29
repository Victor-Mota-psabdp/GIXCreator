SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerDocsAprov_Sel]
(
@ID bigint
)
as

select GNC, Documento [Document],Status from IBROKER_DOC_V2
where ID = @ID




GO
