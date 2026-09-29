SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tipo_Movimento_Del](
	@Id int
)
as
	update Tipo_Movimento set [Enable] = 0 where Id= @Id

GO
