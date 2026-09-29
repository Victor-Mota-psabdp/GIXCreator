SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tipo_Movimento_Sel]--'','','A'
(
	@Id int,
	@Nome_Movimento varchar(300),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 			
			TP.Id						[Id],
			TP.Nome_Movimento			[Movement Name],
			TP.Dt_Created				[Created Date], 
			TP.Dt_Updated				[Updated Date],
			TP.Cd_Usuario				[User Code],
			U.Nome_Usuario				[User Name],
			TP.[Enable]					[Enable]

			from Tipo_Movimento TP with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario	= TP.Cd_Usuario
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			
			TP.Id						[Id],
			TP.Nome_Movimento			[Movement Name],
			TP.Dt_Created				[Created Date], 
			TP.Dt_Updated				[Updated Date],
			TP.Cd_Usuario				[User Code],
			U.Nome_Usuario				[User Name],
			TP.[Enable]					[Enable]

			from Tipo_Movimento TP with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario	= TP.Cd_Usuario
			Where
			TP.Id = @Id
			order by 
			TP.Id,TP.Nome_Movimento
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			
			TP.Id						[Id],
			TP.Nome_Movimento			[Movement Name],
			TP.Dt_Created				[Created Date], 
			TP.Dt_Updated				[Updated Date],
			TP.Cd_Usuario				[User Code],
			U.Nome_Usuario				[User Name],
			TP.[Enable]					[Enable]

			from Tipo_Movimento TP with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario	= TP.Cd_Usuario
			Where
			(
				@Tipo = 'N'
				or
				@Tipo= 'O' and TP.[Enable] = 1
			)
			order by 
			TP.Id,TP.Nome_Movimento
	End
	
--if @Tipo = 'Z'

--END

GO
