SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spNfProduto_Rel] --'%','%', '2008-06-01', '2008-12-31', '%'
	
	@Cliente		varchar(50),
	@Fornecedor		varchar(50),
	@DataInicio		char(10),
	@DataFim		char(10),
	@Enviado		char(1)

as
		if @Enviado = 'N'
			select ID_NF, CNPJ,CL.Apelido, FN.Apelido, Num_NF, Dt_NF, Enviado from Nota_Fiscal_Produto NFP
			left outer join Pessoa CL on NFP.cd_cliente = cl.cd_pes
			left outer join Pessoa FN on NFP.cd_Fornecedor = FN.cd_pes
			where Dt_NF between @DataInicio and @DataFim and CL.Apelido like @Cliente and  FN.Apelido like @Fornecedor  and Enviado is null
			order by Dt_Nf, FN.Apelido
		else
			IF @Enviado = '%'
				select ID_NF, CNPJ,CL.Apelido, FN.Apelido, Num_NF, Dt_NF, Enviado from Nota_Fiscal_Produto NFP
				left outer join Pessoa CL on NFP.cd_cliente = cl.cd_pes
				left outer join Pessoa FN on NFP.cd_Fornecedor = FN.cd_pes
				where Dt_NF between @DataInicio and @DataFim and CL.Apelido like @Cliente and  FN.Apelido like @Fornecedor 
				order by Dt_Nf, FN.Apelido
			else
				select ID_NF, CNPJ,CL.Apelido, FN.Apelido, Num_NF, Dt_NF, Enviado from Nota_Fiscal_Produto NFP
				left outer join Pessoa CL on NFP.cd_cliente = cl.cd_pes
				left outer join Pessoa FN on NFP.cd_Fornecedor = FN.cd_pes
				where Dt_NF between @DataInicio and @DataFim and CL.Apelido like @Cliente and  FN.Apelido like @Fornecedor  and Enviado = 'S'
				order by Dt_Nf, FN.Apelido
	


GO
