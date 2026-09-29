SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help DE_PARA
CREATE PROCEDURE [dbo].[spATL_DE_PARA_Sel]
	@Cd_Cliente		varchar(10),
	@Cd_Tipo		INT,
	@Cd_Org			varchar(2000),
	@Tipo char(1)
	
as


if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			A.Cd_Tipo		[Type],
			T.Nome_Tipo		[Type Name],
			A.Cd_Cliente	[Group Code],
			P.Apelido		[Group Name],			
			Cd_Org			[Origin] ,
			Cd_Dst			[Destination],
			Descr_Org		[Origin Description],
			A.dt_ins		[Insert Date],
			A.Ativo			[Enabled],
			A.Cd_Usuario	[User Code],
			u.Nome_Usuario	[User Name]
		FROM 
			DE_PARA A with(nolock)
			JOIN Pessoa P on P.Cd_Pes = A.Cd_Cliente
			left JOIN Usuario U on U.Cd_Usuario = A.Cd_Usuario
			left JOIN Tipo_De_Para T on T.Cd_Tipo = A.Cd_Tipo
		where 
			A.Cd_Tipo  = @Cd_Tipo
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			A.Cd_Tipo		[Type],
			T.Nome_Tipo		[Type Name],
			A.Cd_Cliente	[Group Code],
			P.Apelido		[Group Name],			
			Cd_Org			[Origin] ,
			Cd_Dst			[Destination],
			Descr_Org		[Origin Description],
			A.dt_ins		[Insert Date],
			A.Ativo			[Enabled],
			A.Cd_Usuario	[User Code],
			u.Nome_Usuario	[User Name]
		FROM 
			DE_PARA A with(nolock)
			JOIN Pessoa P on P.Cd_Pes = A.Cd_Cliente
			left JOIN Usuario U on U.Cd_Usuario = A.Cd_Usuario
			left JOIN Tipo_De_Para T on T.Cd_Tipo = A.Cd_Tipo
		where 
            A.Cd_Cliente = @Cd_Cliente AND A.Cd_Tipo = @Cd_Tipo
			and A.Cd_Org = @Cd_Org
			-- A.Cd_Cliente = @Cd_Cliente AND A.Cd_Tipo  = @Cd_Tipo
			
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			A.Cd_Tipo		[Type],
			T.Nome_Tipo		[Type Name],
			A.Cd_Cliente	[Group Code],
			P.Apelido		[Group Name],			
			Cd_Org			[Origin] ,
			Cd_Dst			[Destination],
			Descr_Org		[Origin Description],
			A.dt_ins		[Insert Date],
			A.Ativo			[Enabled],
			A.Cd_Usuario	[User Code],
			u.Nome_Usuario	[User Name]
		FROM 
			DE_PARA A with(nolock)
			JOIN Pessoa P on P.Cd_Pes = A.Cd_Cliente
			left JOIN Usuario U on U.Cd_Usuario = A.Cd_Usuario
			left JOIN Tipo_De_Para T on T.Cd_Tipo = A.Cd_Tipo
		where 
			A.Cd_Cliente = @Cd_Cliente AND A.Cd_Tipo = @Cd_Tipo
			and A.Cd_Org = @Cd_Org
	End


if @Tipo = 'Q'
	Begin
		SELECT
			A.Cd_Tipo		[Type],
			T.Nome_Tipo		[Type Name],
			A.Cd_Cliente	[Group Code],
			P.Apelido		[Group Name],			
			Cd_Org			[Origin] ,
			Cd_Dst			[Destination],
			Descr_Org		[Origin Description],
			A.dt_ins		[Insert Date],
			A.Ativo			[Enabled],
			A.Cd_Usuario	[User Code],
			u.Nome_Usuario	[User Name]
		FROM 
			DE_PARA A with(nolock)
			JOIN Pessoa P on P.Cd_Pes = A.Cd_Cliente
			left JOIN Usuario U on U.Cd_Usuario = A.Cd_Usuario
			left JOIN Tipo_De_Para T on T.Cd_Tipo = A.Cd_Tipo
		where 
			A.Cd_Cliente = @Cd_Cliente AND A.Cd_Tipo = @Cd_Tipo
			--and A.Cd_Org = @Cd_Org
	End

GO
