SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_View_PO_Modal_Sel 'I%',68,'','R'

--sp_help vwATL_PO_Modal_Sel
CREATE procedure [dbo].[spATL_View_PO_Modal_Sel]
(
	@Num_Proc			varChar(16),
	@ID_DC				int,
	@Numero_PO		varchar(80),
	@Tipo				char(1)
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
			[JOB],	
			[Item],
			[Customer Reference],	
			[Date],
			[Client Doc Type Code],
			[Client Doc Type Name],
			[User Code],
			[User Name],
			[Insert Date]
		from 
			vwATL_PO_Modal_Sel PO with(nolock)			
		where
			[JOB] = @Num_Proc
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			[JOB],	
			[Item],
			[Customer Reference],	
			[Date],
			[Client Doc Type Code],
			[Client Doc Type Name],
			[User Code],
			[User Name],
			[Insert Date]
		from 
			vwATL_PO_Modal_Sel PO with(nolock)			
		where
			[JOB] = @Num_Proc and [Client Doc Type Code] = @ID_DC
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			[JOB],	
			[Item],
			[Customer Reference],	
			[Date],
			[Client Doc Type Code],
			[Client Doc Type Name],
			[User Code],
			[User Name],
			[Insert Date]
		from 
			vwATL_PO_Modal_Sel PO with(nolock)			
		where
			[Customer Reference] = @Numero_PO and [Client Doc Type Code] = @ID_DC
		Order by 
			9
	End

if @Tipo = 'R'
	Begin
		select 
			[JOB],	
			[Item],
			[Customer Reference],	
			[Date],
			[Client Doc Type Code],
			[Client Doc Type Name],
			[User Code],
			[User Name],
			[Insert Date]
		from 
			vwATL_PO_Modal_Sel PO with(nolock)			
		where
			[Client Doc Type Code] = @ID_DC
			and [JOB] like @Num_Proc
			and year([Insert Date]) >= year(getdate()) - 5
			and 
				--(
				[Customer Reference] <> '' 
				--or [Customer Reference] is not null)
	End
--used to find DI on APP XML Reader
if @Tipo = 'P'  or @Tipo = 'O'
	Begin
		select 
			[JOB],	
			[Item],
			[Customer Reference],	
			[Date],
			[Client Doc Type Code],
			[Client Doc Type Name],
			[User Code],
			[User Name],
			[Insert Date]
		from 
			vwATL_PO_Modal_Sel PO with(nolock)			
		where
			[Customer Reference] = @Numero_PO and [Client Doc Type Code] = @ID_DC
			and left([JOB],2) not in ('BO') 
	End
GO
