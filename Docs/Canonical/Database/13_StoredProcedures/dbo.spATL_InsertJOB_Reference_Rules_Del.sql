SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_InsertJOB_Reference_Rules_Del](
	@Id varchar(3)
)
as
	update InsertJOB_Reference_Rules set Status = 0 where Id= @Id

GO
