SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spPessoaATL_Sel 'Bra%il','I','%'
CREATE Procedure [dbo].[spPessoaATL_Sel]-- spPessoaATL_Sel 'Bra%il','G','D%' 
		@Pais	Varchar(50),
		@Tipo	Char(1),
		@Apelido Varchar(50)
/*
Stored utilizada para alimentação de ComboBox de apelido
@Tipo = 
	'E' para cadastro de pessoa do Exterior
	'N' para cadastro de pessoa do Pais
	'T' para todos os cadastros
	'G' só grupos
	'A' para ter um ALL no começo
	'X' para cadastro de pessoa do Pais com Pessoa_Atl_Ax amarrado	
	
	'I' usado no send email para o Inland Trucker
*/
AS

--if @Pais like 'ARG%' or @Pais like 'CHIL%'
--	begin
--		set @Pais = 'ARG%CHIL%'
--	end

Begin
	if @Apelido='%'  or @Apelido='' 
		BEGIN
				if @Tipo = 'E'
					Begin
						select 
								apelido 
						from 
							pessoa PP with(nolock)
							join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
						where 
							desat_pes='N' AND (Pais not like @pais) 
						order by 
							apelido
					End
					if @Tipo = 'N'
						Begin
							select 
									apelido 
							from 
								pessoa PP with(nolock)
								join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
							where 
								desat_pes='N' AND (Pais like @pais) 
							order by 
								apelido
						End
					if @Tipo = 'T'
						Begin
							select 
								apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' 
							order by 
								apelido
						End
					if @Tipo = 'G'
						Begin
							select 
									apelido 
							from 
								pessoa PP with(nolock)
								join grupo GP with(nolock) on GP.Cd_Pes_Grupo=PP.cd_pes 
							where 
								PP.Desat_Pes='N'
							order by 
								apelido
					End					
					if @Tipo = 'A'
						Begin
							select ' ALL' apelido 
								union 
							select 
									apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' 
							order by 
								apelido
						End
					if @Tipo = 'X'
						Begin
							select 
								apelido 
							from 
								pessoa PP with(nolock)
								join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
								Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and AX.Tipo='C'
							where 
								desat_pes='N' AND (Pais like @pais) 
							order by 
								apelido
						End
					if @Tipo = 'I' or @Tipo = 'S' or @Tipo = 'R' 
						Begin							
							select	(Case when @Tipo = 'I' then 'ALL Inland Trucker' else
									(Case when @Tipo = 'S' then 'ALL Suppliers' else	
									 'ALL Agents' 
									end) end) apelido 
								union 
							select 
									apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' 
							order by 
								apelido
						End

			END
		ELSE
			Begin
				if @Tipo = 'E'
					Begin
						select 
								apelido 
						from 
							pessoa PP with(nolock)
							join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
						where 
							desat_pes='N' AND (Pais not like @pais) and apelido like @apelido
						order by 
							apelido
					End
				if @Tipo = 'N'
						Begin
							select 
									apelido 
							from 
								pessoa PP  with(nolock)
								join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
							where 
								desat_pes='N' AND (Pais like @pais) and apelido like @apelido 
							order by 
								apelido
						End
					if @Tipo = 'T'
						Begin
							select 
									apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' and apelido like @apelido
							order by 
								apelido
						End
				if @Tipo = 'G'
					Begin
						select 
								apelido 
						from 
							pessoa PP with(nolock)
							join grupo GP with(nolock) on GP.Cd_Pes_Grupo=PP.cd_pes  
						where 
							PP.Desat_Pes='N' and apelido like @apelido
						order by 
							apelido
					End
				if @Tipo = 'A'
					Begin
							select ' ALL' apelido 
								union ALL 
							select 
								apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' and apelido like @apelido
							order by 
								apelido
						End
				if @Tipo = 'X'
					Begin
							select 
									apelido 
							from 
								pessoa PP  with(nolock)
								join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
								Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and AX.Tipo='C'
							where 
								desat_pes='N' AND (Pais like @pais) and apelido like @apelido 
							order by 
								apelido
						End						
				if @Tipo = 'I' or @Tipo = 'S' or @Tipo = 'R' 
						Begin							
							select	(Case when @Tipo = 'I' then 'ALL Inland Trucker' else
									(Case when @Tipo = 'S' then 'ALL Suppliers' else	
									 'ALL Agents' 
									end) end) apelido 
								union 
							select 
									apelido 
							from 
								pessoa PP with(nolock)
							where 
								desat_pes='N' 
							order by 
								apelido
						End
			End
	end

GO
