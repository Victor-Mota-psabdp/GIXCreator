SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAXDefinirTaxGroupNF_Ins]

as
/*
exec spAXDefinirTaxGroupNF_Ins


	select * 
	from Base_Nota_Fiscal_AX_TAX_GROUP 
	where ref_acesso in ('J')
	ORDER BY CONVERT(INT,NOTA_FISCAL) DESC
*/

Declare @NotaFiscal int
Declare @Ref_Acesso VArchar(1)
Declare @emissao datetime
DEclare @CNPJ varchar(20)
Declare @TotalDia decimal(18,2)
Declare @IDFAt		bigint
Declare @Itemlei varchar(50)
Declare @TaxGroup	varchar(20)

Declare @BaseNF Table
(
	Nota_Fiscal Varchar(8),
	Ref_Acesso	Varchar(1),
	emissao	datetime,
	cd_pes varchar(20)
)

Insert @BaseNF

-- TESTE
--select NF.Nota_Fiscal,NF.ref_Acesso, emissao,cd_pes from base_nota_fiscal NF with(nolock) where cd_status <> '2' and emissao between getdate()-20 and getdate()

-- PRODUCÃO
select NF.Nota_Fiscal,NF.ref_Acesso, emissao,cd_pes from base_nota_fiscal NF with(nolock) where cd_status <> '2' and emissao between getdate()-1 and getdate()

Declare cTemp cursor for
	Select NF.Nota_Fiscal,NF.ref_Acesso, emissao,num_cpf_Cnpj,id_fat,Item_lei from @BaseNF NF
	Join Pessoa PP with(NoLock) on pp.cd_pes=NF.cd_pes
	Join Fatura_Arg F with(NoLock) on F.numero=nota_fiscal and Codigo=Ref_Acesso
	Left Join Base_Nota_Fiscal_AX_TAX_GROUP BNF on nf.nota_fiscal=BNF.nota_fiscal and BNF.ref_Acesso=NF.ref_Acesso
	where --cd_status <> '2' --and emissao between getdate()-15 and getdate()
	--and
	  BNF.nota_fiscal is null
open cTemp 
Fetch Next From cTemp into @NotaFiscal,@Ref_Acesso,@emissao,@CNPJ,@IDFAt,@Itemlei
While @@FETCH_STATUS = 0
			begin
				set @TotalDia = (select sum(total) from fatura_arg where dt_fatura=@emissao and CUIT=@CNPJ and id_fat <=@IDFat)
				if len(LTRIM(RTRIM(@CNPJ))) >10
					Begin
						if @TotalDia <666.67 or @Itemlei = '10.06'
							Begin

								 set @TaxGRoup=(	Case 
										When (@ref_Acesso='J' or @ref_Acesso='K') and @Itemlei = '10.05' then 'CUS SER 10'  -- Alessandra 19/06/2020 
										When (@ref_Acesso='J' or @ref_Acesso='K') then 'CUS SER 14' -- Alessandra 19/05/2020 
										When @ref_Acesso='I' then 'CUS SER 13'
										else 'CUS SER 12'
									End)
							End
						Else
							begin
							 set @TaxGRoup=(	Case 
									When (@ref_Acesso='J' or @ref_Acesso='K')  and @Itemlei = '10.05' then 'CUS SER 08' -- Alessandra 19/06/2020 
									When (@ref_Acesso='J' or @ref_Acesso='K')  then 'CUS SER 04' -- Alessandra 19/05/2020 
									When @ref_Acesso='I' then 'CUS SER 03'
									else 'CUS SER 02'
								End)
							End
					End
				Else
					Begin

						 set @TaxGRoup=(	Case 
								When (@ref_Acesso='J' or @ref_Acesso='K') and @Itemlei = '10.05' then 'CUS SER 09' -- Alessandra 19/06/2020 
								When (@ref_Acesso='J' or @ref_Acesso='K') then 'CUS SER 07' -- Alessandra 19/05/2020 
								When @ref_Acesso='I' then 'CUS SER 05'
								else 'CUS SER 06'
							End)

					End
					--print @TotalDia
					--print @TaxGRoup
					--print @NotaFiscal
					--print @ref_Acesso
					--print @CNPJ
					insert Base_Nota_Fiscal_AX_TAX_GROUP (notA_fiscal,ref_acesso,Tax_Group,Data,CNPJ)values(@NotaFiscal,@ref_Acesso,@taxGroup,getdate(),@CNPJ)
				Fetch Next From cTemp into @NotaFiscal,@Ref_Acesso,@emissao,@CNPJ,@IDFAt,@Itemlei
			End
close cTemp
deallocate cTemp

/*
	Rotina responsavel por definir o tax group considerando a regra de IRRF onde se existir um valor maior que 668 emitido
	no mesmo dia para o mesmo CNPJ precisa utilizar um TAX Group que tenha IRRF

*/
/*
Declare @NotaFiscal int
Declare @Ref_Acesso VArchar(1)
Declare @emissao datetime
DEclare @CNPJ varchar(20)
Declare @TotalDia decimal(18,2)
Declare @IDFAt		bigint
Declare @TaxGroup	varchar(20)

Declare @BaseNF Table
(
	Nota_Fiscal Varchar(8),
	Ref_Acesso	Varchar(1),
	emissao	datetime,
	cd_pes varchar(20)
)

Insert @BaseNF
select NF.Nota_Fiscal,NF.ref_Acesso, emissao,cd_pes from base_nota_fiscal NF with(nolock) where cd_status <> '2' and emissao between getdate()-1 and getdate()

Declare cTemp cursor for
	Select NF.Nota_Fiscal,NF.ref_Acesso, emissao,num_cpf_Cnpj,id_fat from @BaseNF NF
	Join Pessoa PP with(NoLock) on pp.cd_pes=NF.cd_pes
	Join Fatura_Arg F with(NoLock) on F.numero=nota_fiscal and Codigo=Ref_Acesso
	Left Join Base_Nota_Fiscal_AX_TAX_GROUP BNF  on nf.nota_fiscal=BNF.nota_fiscal and BNF.ref_Acesso=NF.ref_Acesso
	where --cd_status <> '2' --and emissao between getdate()-15 and getdate()
	--and
	  BNF.nota_fiscal is null
open cTemp 
Fetch Next From cTemp into @NotaFiscal,@Ref_Acesso,@emissao,@CNPJ,@IDFAt
While @@FETCH_STATUS = 0
			begin
				set @TotalDia = (select sum(total) from fatura_arg with(NoLock) where dt_fatura=@emissao and CUIT=@CNPJ and id_fat <=@IDFat)
				if @TotalDia <668.00 
					Begin
					 set @TaxGRoup=(	Case 
							When @ref_Acesso='I' then 'CUS SER 13'
							else 'CUS SER 12'
						End)
						
						Print 'Aplicar'
					End
				Else
					begin
					 set @TaxGRoup=(	Case 
							When @ref_Acesso='I' then 'CUS SER 03'
							else 'CUS SER 02'
						End)
						

						print 'Nao applicar'
					End
					insert Base_Nota_Fiscal_AX_TAX_GROUP (notA_fiscal,ref_acesso,Tax_Group,Data,CNPJ)values(@NotaFiscal,@ref_Acesso,@taxGroup,getdate(),@CNPJ)
				Fetch Next From cTemp into @NotaFiscal,@Ref_Acesso,@emissao,@CNPJ,@IDFAt
			End
close cTemp
deallocate cTemp

*/
GO
