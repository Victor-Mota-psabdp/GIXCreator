SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--4.1542
CREATE procedure [dbo].[spATL_BuscaParidade_Sel]--'USD','IMM'
(
	@Cd_Tp_Moeda varchar(3),
	@Cd_Tp_Par varchar(3)
)
as
--Declare @Data datetime
--set @Data = '2013-09-27'
if @Cd_Tp_Moeda = 'BRL' or @Cd_Tp_Moeda = 'REL'
	Begin	
		select 1 Paridade
	end
else
	Begin
		select 
			cast((par_Moeda) as Decimal(10,4)) Paridade
			--Par_Moeda Paridade 
		from paridade With(nolock)
		where Cd_Tp_Moeda = @Cd_Tp_Moeda and Cd_Tp_Par = @Cd_Tp_Par and Dt_Par = CONVERT(varchar(10),getdate(),103)
	End


GO
