SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Tipo 'C' completo
--Tipo 'A' só Apelido
CREATE Procedure [dbo].[spATL_PessoaEndCdPes_Sel]-- '10','I'
		@Cd_Pes varchar(10),
		@Tipo char(1)

AS
 if @Tipo = 'C'
	begin
	
		Select		
			Nome_Raz_Soc + '|' +
				isnull(Num_CPF_CNPJ + '|','|') +
				isnull('Street:' + Rua,'|') +
				isnull('Nº:'+ Numero,'|') +
				isnull('-'+compl_end + '|','|') +
				isnull('ZIP Code:'+ltrim(Cep) + '|','|') +
				isnull('City:'+Cidade,'|') Completo
		from
			Pessoa PP
			Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
		Where
			PP.Cd_Pes = @Cd_Pes
	end
	
if @Tipo = 'A'
	begin	
		Select		
				Apelido Completo
			from
				Pessoa			
			Where
				Cd_Pes = @Cd_Pes
	end
if @Tipo = 'S'
	begin
	
		Select
			Apelido,		
			Nome_Raz_Soc,
			Num_CPF_CNPJ,
			Rua,
			Numero,
			compl_end,
			Cep,
			Cidade
		from
			Pessoa PP
			Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
		Where
			PP.Cd_Pes = @Cd_Pes
	end

if @Tipo = 'B'
	begin
	
		Select
			Apelido,		
			Nome_Raz_Soc,
			Num_CPF_CNPJ,
			Rua,
			Numero,
			compl_end,
			Cep,
			Cidade
		from
			Pessoa PP
			Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
		Where
			PP.Cd_Pes = @Cd_Pes and Desat_Pes = 'N'
	end

if @Tipo = 'G'
	begin	
		Select
			Apelido		
			
		from
			Pessoa PP
			Join Grupo G with(nolock) on G.Cd_Pes_Grupo =pp.cd_pes
		Where
			PP.Cd_Pes = @Cd_Pes and Desat_Pes = 'N'
	end
	
if @Tipo = 'I'
	begin
	
		Select		
			PP.Nome_Raz_Soc + '|' +
				isnull(PP.Num_CPF_CNPJ + '|','|') +
				isnull('Street:' + ED.Rua,'|') + isnull('Nº:'+ ED.Numero,',|') +
				isnull('-' + ED.compl_end + '  |','|') +
				isnull('CEP: '+ltrim(ED.Cep) + '|','|') +
				isnull(ED.Cidade,'|') +
				isnull(ED.Pais + '-' + ED.CD_pais,'|') Completo,
			PP.Apelido,		
			PP.Nome_Raz_Soc,
			PP.Num_CPF_CNPJ,
			ED.Rua,
			ED.Numero,
			ED.compl_end,
			ED.Cep,
			ED.Cidade,
			ED.CD_pais
		from
			Pessoa PP
			Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
			left join Grupo G on G.Cd_Pes_Grupo = PP.Cd_Pes
		Where
			PP.Cd_Pes = @Cd_Pes
			and G.Grupo is null
	end


if @Tipo = 'F'
	BEGIN
		Select 
			Cd_Pes
		from 
			Pessoa With(nolock) 
		where 
			Cd_Pes = @Cd_Pes 
		and (len(num_cpf_cnpj) >= 14 OR CD_TP_ATIV='AGT') 
		and Desat_Pes = 'N' 
	END
	
if @Tipo = 'E'
	BEGIN
		Select 
			PS.Cd_Pes, 
			ED.Pais
		from Pessoa PS with(nolock)
			join Endereco ED with(nolock) on PS.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
            where PS.Cd_Pes = @Cd_Pes
	END




GO
