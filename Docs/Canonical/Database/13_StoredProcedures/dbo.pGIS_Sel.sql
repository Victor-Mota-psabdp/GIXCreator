SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pGIS_Sel
(
@DC			Char(1), 
@Tipo			Char(1)='%',
@Data01		Datetime, 
@Data02		Datetime,
@Site			Char(1) = 'B'
)

--Tipo: (F) Fatura    (D) Diversos 
AS
If @DC = 'D'
	Begin 
		If @Tipo = 'F'
			Begin 

				Print 'Erro'
			End 
	End
Else
	Begin 

		Select 
			'03706460000128' as CNPJ_Declar, 'NFS' as Tp_Nota, BNF.Cd_Pes, 
			'5777' as Cd_Serv_ISS, BNF.Nota_Fiscal as NF, BNF.Ref_Acesso Site, 
			Situacao = 
			Case 
				When Cd_Status = 2 then '2' 
				When Cd_Status = 1 then '1'
			End,
			BNF.Emissao as Emissao, 
			Valor_Total as Vlr_Tbt, 
			Cli.Num_CPF_CNPJ  CNPJ_Tomador ,
			UPPER(Ender.Cidade) Nome_Cidade, BNF.Nota_Fiscal Docto, 
			Ender.Cidade, Ender.Pais, Ender.UF UF_Tomador,  Cli.Nome_Raz_Soc Razao_Tomador, 
			IM_Tomador = 
			Case 
				When UPPER(Ender.Cidade) = 'SANTOS'  then Cli.Num_Insc_Munic 
				Else '0000000000'
			End, 

			Num_RG_IE IE_Tomador, Ender.CEP CEP_Tomador, Ender.Rua Rua_Tomador, 
			Ender.Numero Numero_Tomador, Ender.Compl_End Comp_Tomador, Ender.Bairro Bairro_Tomador, 
			Ender.Pais, Cli.Cd_Tp_Pes 
		From 
			Base_Nota_Fiscal as BNF Join Pessoa as Cli on Cli.Cd_Pes = BNF.Cd_pes 
			Left Outer Join Endereco as Ender on Ender.Cd_Pes = BNF.Cd_Pes and Ender.Cd_Tp_End = 'COM'
		Where
			BNF.Ref_Acesso = @Site and
			Convert(DateTime, Emissao, 105) between @Data01 and @Data02  and 
			(Cd_Status = 1 or Cd_Status = 2)

	End
GO
