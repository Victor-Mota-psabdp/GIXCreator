SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_InsertJOB_Order_Fields_Del]
(
	@Id INT
)
as
	UPDATE InsertJOB_Order_Fields SET Status= 0 where Id= @Id

GO
