SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pISSREC_Sel
(
@DC			Char(1), 
@Tipo			Char(1)='%',
@Data01		Datetime, 
@Data02		Datetime,
@Site			Char(1) = 'C'
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
			Ref_CNPJ as CNPJ_Declar, Ref_IM as IM_Declar, 
			'NFS' as Tp_Nota, BNF.Cd_Pes, 
			'06297' as Cd_Serv_ISS, BNF.Nota_Fiscal as NF, BNF.Ref_Acesso Site, 
			Situacao = 
			Case 
				When Cd_Status = 2 then 'C' 
				When Cd_Status = 1 then 'A'
			End,
			BNF.Emissao as Emissao, 
			Valor_Total as Vlr_Tbt, 
			CNPJ_Tomador =
			Case 
				When Cli.Cd_Tp_Pes = 'E' then  '00099999999050' 
				When Cli.Cd_Tp_Pes = 'J' then  substring(Cli.Num_CPF_CNPJ , 2, len(Cli.Num_CPF_CNPJ)  -1   )
				Else Cli.Num_CPF_CNPJ 
			End, 
			Ender.Cidade Nome_Cidade, BNF.Nota_Fiscal Docto, 
			Ender.Cidade, Ender.Pais, Ender.UF UF_Tomador,  Cli.Nome_Raz_Soc Razao_Tomador, Cli.Num_Insc_Munic IM_Tomador, 
			Num_RG_IE IE_Tomador, Ender.CEP CEP_Tomador, Ender.Rua Rua_Tomador, 
			Ender.Numero Numero_Tomador, Ender.Compl_End Comp_Tomador, Ender.Bairro Bairro_Tomador, 
			Ender.Pais, Cli.Cd_Tp_Pes , Aliq_ISS, Valor_ISS
		From 
			Base_Nota_Fiscal as BNF Join Pessoa as Cli on Cli.Cd_Pes = BNF.Cd_pes 
			Left Outer Join Endereco as Ender on Ender.Cd_Pes = BNF.Cd_Pes and Ender.Cd_Tp_End = 'COM'
			Join Referencia Ref on Ref.Ref_Acesso = 'C'
		Where
			BNF.Ref_Acesso = @Site and
			Convert(DateTime, Emissao, 105) between @Data01 and @Data02  and 
			(Cd_Status = 1 or Cd_Status = 2)

	End
GO
