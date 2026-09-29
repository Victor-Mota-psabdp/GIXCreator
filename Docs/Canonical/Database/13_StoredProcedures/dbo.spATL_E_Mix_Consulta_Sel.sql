SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help E_Mix_Consulta
-- [dbo].[spATL_E_Mix_Consulta_Sel] '31','','B'
CREATE PROCEDURE [dbo].[spATL_E_Mix_Consulta_Sel]
(
	@Id_Consulta_Tipo	int,	
	@Num_Proc			varchar(16),
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			'102'								[Id_Cliente],
			'140'								[Id_Integracao],
			'1a28c0af0dd545f0d7bd20a0d5c92d7f'	[Contra_Senha],
			C.id								[Id],
			C.id_servico						[Id_Servico],	
			C.id_empresa						[Id_Empresa],
			C.id_cnpj							[Id_Cnpj],
			C.id_consulta_tipo					[Id_Consulta_Tipo],
			C.id_parametro_grupo				[Id_Parametro_Grupo],
			C.id_parametro_tipo					[Id_Parametro_Tipo],
			C.valor								[Valor],	
			C.num_proc							[Num_Proc],
			C.id_parametro_grupo				[Id_Recuperacao]
		from E_Mix_Consulta	C with(nolock)
			Left Join E_MIX_XML E with(nolock) on E.id=C.id		
		where 
			C.dt_ins > GETDATE() -31 and 
            C.id_consulta_tipo = @Id_Consulta_Tipo
			and E.Num_Proc is null 
			 
			--and LEFT(C.Num_Proc,1) = 'E'
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			'102'								[Id_Cliente],
			'140'								[Id_Integracao],
			'1a28c0af0dd545f0d7bd20a0d5c92d7f'	[Contra_Senha],
			C.id								[Id],
			C.id_servico						[Id_Servico],	
			C.id_empresa						[Id_Empresa],
			C.id_cnpj							[Id_Cnpj],
			C.id_consulta_tipo					[Id_Consulta_Tipo],
			C.id_parametro_grupo				[Id_Parametro_Grupo],
			C.id_parametro_tipo					[Id_Parametro_Tipo],
			C.valor								[Valor],	
			C.num_proc							[Num_Proc],
			C.id_parametro_grupo				[Id_Recuperacao]
		from E_Mix_Consulta	C with(nolock)
			Left Join E_MIX_XML E with(nolock) on E.id=C.id		
		where
            C.id_consulta_tipo = @Id_Consulta_Tipo
			and C.Num_Proc = @Num_Proc
			and E.Num_Proc is null 
			
	End
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area  with(nolock)
--		where Nome_Area = @Nome_Area
--	End
	
--if @Tipo = 'Z'-- or @Tipo = 'O'
--	Begin
--		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area  with(nolock)
--		where Nome_Area = @Nome_Area and Cd_Area <> @Cd_Area
--	End

	

GO
