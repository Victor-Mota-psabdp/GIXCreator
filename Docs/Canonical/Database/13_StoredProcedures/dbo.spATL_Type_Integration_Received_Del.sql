SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Type_Integration_Received
CREATE procedure [dbo].[spATL_Type_Integration_Received_Del]
(
	@Id_Integration_Received BIGINT
)
as
	UPDATE Type_Integration_Received SET Status= 0 where Id_Integration_Received= @Id_Integration_Received

GO
