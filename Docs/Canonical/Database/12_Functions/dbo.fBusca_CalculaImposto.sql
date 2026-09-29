SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Tax_AX
--select * from Tipo_Taxa where CodigoTP = 'DEM'

--Sales Tax: 3.2.3.001.001 a 3.2.3.001.099

CREATE function [dbo].[fBusca_CalculaImposto](
	@Processo	varchar(16),
	@NomeTaxa	varchar(200),
	@DC			char(1),
	@Valor		float
)
RETURNS float

AS

--Declare @Processo	varchar(16)
--Declare	@NomeTaxa	varchar(200)
--Declare	@DC			char(1)
--Declare @Valor		float
--select * from VWCta_Cte where Num_Proc_HIA ='EMFMC201602003BR' and DC_HIA = 'C' and Cd_Tp_Tx ='160'
--set @Processo  = 'EMFMC201602003BR'
--set @DC = 'C'
--Set @NomeTaxa = 'AMS Ocean 1 - BDP'
--set @Valor = 304.07

BEGIN

Declare @Resultado as float
Declare @Nota_Fiscal as Varchar(10)
Declare @site	as varchar(1)

Declare @CodigoTP	as varchar(6)
set @CodigoTP = (select CodigoTP from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @NomeTaxa)

Declare @item_lei as varchar(10)

set @Nota_Fiscal =(Select V.Num_NF_HIA from vwcta_Cte V with(nolock)
						join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx = V.Cd_Tp_Tx
					Where 
						Num_Proc_HIA = @Processo and V.DC_HIA = @DC and TT.Nome_Tp_Tx = @NomeTaxa)
	
set @site =(Select V.Ref_Acesso_NF_HIA from vwcta_Cte V with(nolock)
				join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx = V.Cd_Tp_Tx
			Where 
				Num_Proc_HIA = @Processo and V.DC_HIA = @DC and TT.Nome_Tp_Tx = @NomeTaxa)

if @Nota_Fiscal is not null and @site is not null
	--set @item_lei = (select item_lei from Base_Nota_Fiscal B
	--				join Pessoa P on P.Cd_Pes = B.Cd_Pes
	--				where 
	--					Nota_Fiscal =@Nota_Fiscal and Ref_Acesso = @site
	--				and 
	--					(P.Num_CPF_CNPJ is not null or P.Num_CPF_CNPJ <> ''))


	BEGIN	
	
		if @site= 'I' and @CodigoTP = 'DEM'
			BEGIN
				--?Demurrage: 1,65% (Pis) + 7,60% (Cofins) = Total 9,25%
				set @Resultado = (select convert(decimal(10,2),.0165 * @Valor) 
								 + convert(decimal(10,2),.076 * @Valor)) 
			end
		else
			BEGIN
				--Santos: 1,65% (Pis) + 7,60% (Cofins) + 3% (Iss) = Total 12,25%
				set @Resultado = (select convert(decimal(10,2),.03 * @Valor)
								 + convert(decimal(10,2),.0165 * @Valor) 
								 + convert(decimal(10,2),.076 * @Valor)) 
			end
			
		if @site= 'A' and @CodigoTP = 'DEM'
			BEGIN
				--São Paulo: 1,65% (Pis) + 7,60% (Cofins) + 5% (Iss) = Total 14,25%
				set @Resultado = (select convert(decimal(10,2),.0165 * @Valor) 
							 + convert(decimal(10,2),.076 * @Valor)) 
			end
		else
			BEGIN
				--Santos: 1,65% (Pis) + 7,60% (Cofins) + 3% (Iss) = Total 12,25%
				set @Resultado = (select convert(decimal(10,2),.03 * @Valor)
								 + convert(decimal(10,2),.0165 * @Valor) 
								 + convert(decimal(10,2),.076 * @Valor)) 
			end
		
	END


	return @Resultado
END


GO
