SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spINTUserSOLAS]

		@Num_proc	varchar(16)

as

select top 1 Nome_Responsavel_VGM usuario from Container_Additional_Info
Where num_proc=@Num_Proc and ativo = 1


GO
