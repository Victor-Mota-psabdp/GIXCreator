SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CADU 16/08/2022  -12:33h
CREATE procedure [dbo].[spATLDN_Terminal_Sel]
(
	@Cd_Terminal char(3),
	@Nome_Terminal varchar(30),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O, /// Busca pelo Nome - Ativos
R  /// buscar pelo cd_repart 
*/

if @Tipo = 'A'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Cd_Terminal <> '0'
	End
	
if @Tipo = 'B'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Cd_Terminal <> '0'
		and Ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Cd_Terminal = @Cd_Terminal
		and Cd_Terminal <> '0'
	End
	
if @Tipo = 'D'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Cd_Terminal = @Cd_Terminal
		and Cd_Terminal <> '0'
		and Ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Nome_Terminal = @Nome_Terminal
		and Cd_Terminal <> '0'
	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Nome_Terminal = @Nome_Terminal
		and Cd_Terminal <> '0'
		and Ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where Nome_Terminal = @Nome_Terminal AND Cd_Terminal <> @Cd_Terminal
		and Cd_Terminal <> '0'
	End

--Verify if Cd_Repart already included in another Terminal
if  @Tipo = 'P'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where t.Cd_Repart = @Nome_Terminal AND Cd_Terminal <> @Cd_Terminal
		and Cd_Terminal <> '0'
	End

if  @Tipo = 'R'
	Begin
		select 
			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
			T.ativo [Enabled]
			,T.Dt_Ins [Insert Date]
		from Terminal T with(nolock)
		left join Usuario U on U.Cd_Usuario = T.cd_usuario
		where t.Cd_Repart =  @Nome_Terminal
		and Cd_Terminal <> '0'
	End


	

	
--ALTER procedure [dbo].[spATLDN_Terminal_Sel](
--	@Cd_Terminal char(3),
--	@Nome_Terminal varchar(30),
--	@Tipo char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--*/

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		select 
--			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
--			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
--			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
--			T.ativo [Enabled]
--		from Terminal T with(nolock)
--		left join Usuario U on U.Cd_Usuario = T.cd_usuario
--		where Cd_Terminal <> '0'
--	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--		select 
--			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
--			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
--			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
--			T.ativo [Enabled]
--		from Terminal T with(nolock)
--		left join Usuario U on U.Cd_Usuario = T.cd_usuario
--		where Cd_Terminal = @Cd_Terminal
--		and Cd_Terminal <> '0'
--	End
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 
--			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
--			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
--			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
--			T.ativo [Enabled]
--		from Terminal T with(nolock)
--		left join Usuario U on U.Cd_Usuario = T.cd_usuario
--		where Nome_Terminal = @Nome_Terminal
--		and Cd_Terminal <> '0'
--	End
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select 
--			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
--			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
--			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
--			T.ativo [Enabled]
--		from Terminal T with(nolock)
--		left join Usuario U on U.Cd_Usuario = T.cd_usuario
--		where Nome_Terminal = @Nome_Terminal AND Cd_Terminal <> @Cd_Terminal
--		and Cd_Terminal <> '0'
--	End

--if  @Tipo = 'P'
--	Begin
--		select 
--			Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
--			t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
--			t.cd_usuario [User Code],U.Nome_Usuario [User Name],
--			T.ativo [Enabled]
--		from Terminal T with(nolock)
--		left join Usuario U on U.Cd_Usuario = T.cd_usuario
--		where t.Cd_Repart = @Nome_Terminal AND Cd_Terminal <> @Cd_Terminal
--		and Cd_Terminal <> '0'
--	End

----if @Tipo = 'A' or @Tipo = 'B'
----	Begin
----		select Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name], 
----		Cd_Repart, -- [Division],
----		Cd_Term_Ofc , --[Official Code],
----		Email [Email],
----		Email_CC, -- [Copy]
----		cd_usuario
----		from Terminal with(nolock)
----		where Cd_Terminal <> '0'
----	End
----if @Tipo = 'C' or @Tipo = 'D'
----	Begin
----		select Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name], 
----		Cd_Repart, -- [Division],
----		Cd_Term_Ofc , --[Official Code],
----		Email [Email],
----		Email_CC, -- [Copy]
----		cd_usuario
----		from Terminal with(nolock)
----		where Cd_Terminal = @Cd_Terminal
----		and Cd_Terminal <> '0'
----	End
----if @Tipo = 'N' or @Tipo = 'O'
----	Begin
----		select Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name], 
----		Cd_Repart, -- [Division],
----		Cd_Term_Ofc , --[Official Code],
----		Email [Email],
----		Email_CC, -- [Copy]
----		cd_usuario
----		from Terminal with(nolock)
----		where Nome_Terminal = @Nome_Terminal
----		and Cd_Terminal <> '0'
----	End	
----if @Tipo = 'Z' --or @Tipo = 'O'
----	Begin
----		select Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name], 
----		Cd_Repart, -- [Division],
----		Cd_Term_Ofc , --[Official Code],
----		Email [Email],
----		Email_CC, -- [Copy]
----		cd_usuario
----		from Terminal with(nolock)
----		where Nome_Terminal = @Nome_Terminal AND Cd_Terminal <> @Cd_Terminal
----		and Cd_Terminal <> '0'
----	End
	

	
GO
