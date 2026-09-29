SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDES_Sel
(
@DC			Char(1), 
@Tipo			Char(1)='%',
@Data01		Datetime, 
@Data02		Datetime
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
			'03706460000128' as CNPJ_Declar, 'NFS' as Tp_Nota, 
			'06297' as Cd_Serv_ISS, BNF.Nota_Fiscal as NF, 
			Situacao = 
			Case 
				When Cd_Status = 2 then 'C' 
				When Cd_Status = 1 then 'T'
			End,
			BNF.Emissao as Emissao, 
			Valor_Total as Vlr_Tbt, 
			Cli.Num_CPF_CNPJ as CNPJ_Tomador, 
			Nome_Cidade = 
			Case
				When Upper(Ender.Cidade) = 'SÃO PAULO' then 'SÃO PAULO'
				When Upper(Ender.Cidade) <> 'SÃO PAULO' and Ender.Pais = 'BRASIL' then 'OUTROS MUNICÍPIOS'
				Else 'EXTERIOR' 
			End, 				
			BNF.Nota_Fiscal as Docto, Ender.Cidade, Ender.Pais
		From 
			Base_Nota_Fiscal as BNF Join Pessoa as Cli on Cli.Cd_Pes = BNF.Cd_pes 
			Left Outer Join Endereco as Ender on Ender.Cd_Pes = BNF.Cd_Pes and Ender.Cd_Tp_End = 'COM'
		Where
			BNF.Ref_Acesso = 'A' and
			Convert(DateTime, Emissao, 105) between @Data01 and @Data02  and 
			(Cd_Status = 1 or Cd_Status = 2)

	End

GO
