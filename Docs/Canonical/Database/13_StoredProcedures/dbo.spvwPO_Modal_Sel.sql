SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help vwPO_Modal_Sel
CREATE procedure [dbo].[spvwPO_Modal_Sel]
(
	@Num_proc	varChar(16),
	@ID_DC		int,
	@Tipo		char(1)
)

as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
if @Tipo = 'A'  or @Tipo = 'B'

	Begin
		select 
			[JOB],	[Item],	[Customer Reference],	
			[Date],[Doc Type Code],[Doc Type],[User Code],
			[User],[Insert Date]
		from 
			vwPO_Modal_Sel TT with(nolock)			
		where
			[JOB] = @Num_proc
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			[JOB],	[Item],	[Customer Reference],	
			[Date],[Doc Type Code],[Doc Type],[User Code],
			[User],[Insert Date]
		from 
			vwPO_Modal_Sel TT with(nolock)			
		where
			[JOB] = @Num_proc and [Doc Type Code] = @ID_DC
	End

GO
