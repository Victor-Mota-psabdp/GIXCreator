SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFaturaBDP_BO_Sel] --'IMCSR20090522301','DOW BRASIL S 0962326'
(
@Processo	varchar(16)
)


AS
	select distinct fatcod from vwFaturasValidas where Num_Proc = @Processo












GO
