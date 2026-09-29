SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_NFe_CancelaRPS_Sel]--'2016-01-01','2016-12-31','H'  
(
	 @dtInicial		datetime,  
	 @dtFinal		datetime,  
	 @Site			char(1)  
)

as  
  
if @Site = 'I'  
	select       
		BNF.RPS_NFE			[Nota Fiscal],  
		'03706460000209'	[Cnpj],  
		'1366280'			[InscricaoMunicipal],  
		'3548500'			[CodigoMunicipio],
		bnf.Nota_Fiscal		[NF]
		--,'0001'					[CodigoCancelamento]
		,'1'					[CodigoCancelamento]
	from   
		base_nota_fiscal BNF     
	where  
		BNF.Ref_Acesso = @Site    
		and BNF.Cd_Status = 2   
		and BNF.RPS_Envio  = 1  
		and (dt_Cancel between @dtInicial and @dtFinal)   
		and BNF.Protocolo is not null  
		and dt_Cancel_prefeitura is null  
	order by 
		BNF.RPS_NFE  

--Alessandra 10/07/2020 - 100-215446 - NF Sao Caetano  
if @site ='K'  
	select   
		BNF.RPS_NFE			[Nota Fiscal],    
		'03706460000128'	[Cnpj],  
		'113543'			[InscricaoMunicipal], 
		'3548807'			[CodigoMunicipio] ,
		bnf.Nota_Fiscal		[NF],    
		'113543' +  right('000000000000' + BNF.RPS_NFE,12) [Assinatura] 
		,'1'					[CodigoCancelamento]
	from 
		base_nota_fiscal BNF      
	where  
		BNF.Ref_Acesso = 'K'  
		and BNF.Cd_Status = 2   
		and BNF.RPS_Envio  = 1  
		and dt_Cancel_prefeitura is null
		and dt_Cancel > getdate() -120
		and BNF.Nota_Fiscal not in (34222)
	order by
		BNF.RPS_NFE  
  
if @Site = 'H'  
 select       
  BNF.RPS_NFE    [Nota Fiscal],  
  --[Prestador]  
  '03706460000713'  [Cnpj],  
  '1217852'    [InscricaoMunicipal],  
  bnf.Nota_Fiscal   [NF],  
  '3205309'    [CodigoMunicipio]  
    
 from   
  base_nota_fiscal BNF     
 where  
  BNF.Ref_Acesso = 'H'   
  and BNF.Cd_Status = 2   
  and BNF.RPS_Envio  = 1  
  and (dt_Cancel between @dtInicial and @dtFinal)   
  and BNF.Protocolo is not null  
  and dt_Cancel_prefeitura is null  
  --and BNF.RPS_NFE  = '1899'  
    
if @site ='A'  
 select   
  BNF.RPS_NFE    [Nota Fiscal],    
  '03706460000128'  [Cnpj],  
  '28921712'    [InscricaoMunicipal],  
  bnf.Nota_Fiscal   [NF],  
    
  '28921712' +  right('000000000000' + BNF.RPS_NFE,12) [Assinatura]    
 from base_nota_fiscal BNF      
 where  
  BNF.Ref_Acesso = @Site  
  and BNF.Cd_Status = 2   
  and BNF.RPS_Envio  = 1  
  and (dt_Cancel between @dtInicial and @dtFinal)   
  --and BNF.Protocolo is not null  
  and dt_Cancel_prefeitura is null  
  and dt_Cancel > '2017-06-09'  
  and convert(int,BNF.Nota_Fiscal) >= 110811  
  --iniciei o envio dia 16/6 com a nf 110811  

--Alessandra 05/05/2020 - 100-215446 - NF Sao Caetano
if @site ='J'  
 select   
  BNF.RPS_NFE    [Nota Fiscal],    
  '03706460000985'  [Cnpj],  
  '112691'    [InscricaoMunicipal],  
  bnf.Nota_Fiscal   [NF],  
    
  '112691' +  right('000000000000' + BNF.RPS_NFE,12) [Assinatura]    
 from base_nota_fiscal BNF      
 where  
  BNF.Ref_Acesso = @Site  
  and BNF.Cd_Status = 2   
  and BNF.RPS_Envio  = 1  
  --and (dt_Cancel between @dtInicial and @dtFinal)   
  and dt_Cancel_prefeitura is null  
  --and convert(int,BNF.Nota_Fiscal) >= 110811  
  
order by BNF.RPS_NFE  
  


   
--cancelados manualmente pelo Bruno X Siberio na Prefeitura  
--update Base_Nota_Fiscal set dt_Cancel_Prefeitura = GETDATE() -1, Condicoes = 'Manualmente na Prefeitura'   
--where Ref_Acesso = 'I' and Nota_Fiscal in (  
--3812,3813,3814,3815,3816,3817,3818,3819,3820,3821,3822,3823,3824,3825,3826,3827,3828,3829,3830,  
--3859,3860,3861,3862,3863,3865,3868,3872,3873,3889,3890,3891,3892,3893,3894,3895,3896,3897,3898,  
--3899,3900,3901,3902,3903,3904,3905,3906,3907,3908,3909,3835,3836,3837,3838,3839)  
GO
