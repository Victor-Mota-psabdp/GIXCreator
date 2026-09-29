SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[spATL_NFeSaoCaetano_RPS_Sel]--3889  
 @NF VARCHAR(10)  
AS  
/*  
spATL_NFeSaoCaetano_RPS_Sel 3  
  
*/  
   
 SET NOCOUNT ON  
  
 Declare @Nota Table  
  (  
  Numero      VARCHAR(10),   
  Serie      VARCHAR(1),   
  Tipo      VARCHAR(1),   
  DataEmissao     VARCHAR(25),        
  NaturezaOperacao   VARCHAR(1),   
  RegimeEspecialTributacao VARCHAR(1),   
  OptanteSimplesNaciONal  VARCHAR(1),   
  IncentivadorCultural  VARCHAR(1),   
  [Status]     VARCHAR(1),    
  ValorServicos    DECIMAL(10,2),  
  ValorPis     DECIMAL(10,2),   
  ValorCofins     DECIMAL(10,2),   
  ValorInss     DECIMAL(10,2),   
  ValorIr      DECIMAL(10,2),  
  ValorCsll     DECIMAL(10,2),   
  IssRetido     INT,       
  ValorIssRetido    DECIMAL(10,2),   
  ValorIss     DECIMAL(10,2),  
  BaseCalculo     DECIMAL(10,2),  
  Aliquota     DECIMAL(10,3),  
  ValorLiquidONfse   DECIMAL(10,2),   
  ItemListaServico   VARCHAR(10),    
  CodigoCnae     VARCHAR(10),  
  CodigoTributacaoMunicipio VARCHAR(10),   
  CodigoMunicipio    VARCHAR(10),  
  Discriminacao    VARCHAR(MAX),  
  MunicipioPrestacaoServico VARCHAR(10),   
  Cnpj      VARCHAR(25),  
  InscricaoMunicipal   VARCHAR(25),   
  CpfCnpj      VARCHAR(25),   
  CpfInscricaoMunicipal  VARCHAR(25),   
  RazaoSocial     VARCHAR(60),  
  Endereco     VARCHAR(100),   
  NumeroEnd     VARCHAR(25),  
  Complemento     VARCHAR(25),   
  Bairro      VARCHAR(50),  
  Cidade      VARCHAR(50),  
  CodigoMunicipioE   VARCHAR(10),  
  CodigoMunicipioEnd   VARCHAR(10),   
  Uf       VARCHAR(10),  
  Estado      VARCHAR(50),  
  Cep       VARCHAR(25),  
  TelefONe     VARCHAR(25),   
  Email      VARCHAR(50),  
  Ref_Acesso     VARCHAR(1),  
  ValorCargaTributaria  DECIMAL(10,2),  
  Pais      VARCHAR(100)   
 )  
  
 BEGIN   
  INSERT INTO @Nota   
  SELECT DISTINCT  
  -- [IdentificacaoRps]       
  BNF.Nota_Fiscal           [Numero]   
  ,'1'             [Serie]  
  ,'1'             [Tipo]   
  -- [IdentificacaoRps]  
    
  ,CONVERT(VARCHAR(10), BNF.Emissao,120)+ 'T00:00:00'  [DataEmissao]  
  ,'1'             [NaturezaOperacao]   
  ,'1'             [RegimeEspecialTributacao] --NO   
  ,'2'             [OptanteSimplesNaciONal] --MO  
  ,'2'             [IncentivadorCultural]--NO  
     
  ,(CASE WHEN BNF.cd_status = 0 THEN   
   1   
  ELSE   
   BNF.cd_status   
  END)             [Status]  
     
  -- [Servico]  
  -- [Valores]      
  ,ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00') [ValorServicos]  
       
  -- [ValorPis],     
  -- PIS -  Alíquotas  0,65% se o valor das notas emitidas no dia atingir R$ 215,17  
  ,(CASE WHEN BNF.Item_lei = '33.01' AND BNF.Valor_Total > 215.17  AND (T.num_cpf_cnpj IS NOT NULL) THEN   
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0065*BNF.Valor_Total)),'0.00')  
  ELSE   
   '0.00'   
  END)             [ValorPis]  
      
  -- [ValorCofins],  
  -- COFINS - Alíquota 3% se o valor das notas emitidas no dia atingir R$ 215,17  
  ,(CASE WHEN BNF.Item_lei = '33.01' AND BNF.Valor_Total > 215.17 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.03* BNF.Valor_Total)),'0.00')  
  ELSE   
   '0.00'   
  END)             [ValorCofins]  
        
  -- [ValorInss],   
  -- INSS -  não preenche             
  ,'0.00' [ValorInss]   
       
  -- [ValorIr],      
  -- IR - 1,5% se o valor das notas emitidas no dia atingir R$ 666,67  
  ,(CASE WHEN BNF.Item_lei in ('33.01','10.05') AND BNF.Valor_Total > 666.67 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.015* BNF.Valor_Total)),'0.00')  
  ELSE   
   (CASE WHEN BNF.IRRF_Tx= 'S' THEN   
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.015* BNF.Valor_Total)),'0.00')  
   ELSE   
    '0.00'   
   END)  
  END)             [ValorIr]   
         
         
  -- [ValorCsll],  
  -- CSLL - Alíquota 1% se se se o valor das notas emitidas no dia atingir R$ 215,17  
  ,(CASE WHEN BNF.Item_lei = '33.01'  AND BNF.Valor_Total > 215.17 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.01* BNF.Valor_Total)),'0.00')  
  ELSE   
   '0.00'   
  END)             [ValorCsll]  
     
  --[IssRetido]  
  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN  
   '1'   
  ELSE   
   '2'   
  END)             [IssRetido]--1 SIM | 2 Não  
      
  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN   
   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
   (CASE WHEN BNF.Item_lei = '10.05' THEN  
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
   ELSE  
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')  
   END)  
  ELSE   
   '0.00'   
  END)                    [ValorIssRetido]  
       
  
  --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
  ,(CASE WHEN BNF.Item_lei = '10.05' THEN  
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
  ELSE  
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')   
  END)                    [ValorIss]  
       
  ,ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00')    [BaseCalculo]     
       
  --ALESSANDRA 04/05/2020 - CONforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorizatiON AND duratiON" para a taxa item lei "10.05" cONsiderar a taxa de ISS é 2,5%   
  ,CONVERT(VARCHAR,CONVERT(DECIMAL(5,3),(CASE WHEN BNF.Item_lei = '10.05' THEN  
   '0.025'   
  ELSE  
   '0.02'   
  END)))                    [Aliquota]  
        
  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN   
   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
   (CASE WHEN BNF.Item_lei = '10.05' THEN  
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total) - CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
   ELSE  
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total) - CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')  
   END)  
  ELSE  
   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00')  
  END)                    [ValorLiquidoNfse]  
  --[Valores]  
  
  ,replace(BNF.Item_lei,'.','')              [ItemListaServico]   
  ,replace(BNF.CNAE,'.','')               [CodigoCnae]   
  ,replace(BNF.cd_servico,'.','')              [CodigoTributacaoMunicipio]  
  ,'3548807'                   [CodigoMunicipio]  
     
  --qdo o Endereco eh de fora, só deve ir o iss  
  ,(CASE WHEN T.num_cpf_cnpj = '' OR T.num_cpf_cnpj IS NULL THEN  
   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
   (CASE WHEN BNF.Item_lei = '10.05' THEN  
    [DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
    ' | Conforme Lei 12.741/2012: ISS 2,5% R$ ' +    
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00') +   
    ',  PIS 1,65% R$ ' + '0.00' +  
    ' e Confins 7,6% R$ ' + '0.00'     
   ELSE  
    [DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
    ' | Conforme Lei 12.741/2012: ISS 2% R$ ' +    
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00') +   
    ',  PIS 1,65% R$ ' + '0.00' +  
    ' e Confins 7,6% R$ ' + '0.00'  
   END)  
  ELSE  
   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
   (CASE WHEN BNF.Item_lei = '10.05' THEN  
    [DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
    ' | Conforme Lei 12.741/2012: ISS 2,5% R$ ' +    
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00') +   
    ',  PIS 1,65% R$ ' +   
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0165*BNF.Valor_Total)),'0.00') +  
    ' e Confins 7,6% R$ ' +   
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.076* BNF.Valor_Total)),'0.00')  
   ELSE  
    [DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
    ' | Conforme Lei 12.741/2012: ISS 2% R$ ' +    
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00') +   
    ',  PIS 1,65% R$ ' +   
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0165*BNF.Valor_Total)),'0.00') +  
    ' e Confins 7,6% R$ ' +   
    ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.076* BNF.Valor_Total)),'0.00')    
   END)  
  
     
  END)                    [Discriminacao]  
         
  ,''                     [MunicipioPrestacaoServico] --NO  
  --[Servico]  
  
  --[Prestador]  
  ,'03706460000985'                 [Cnpj]  
  ,'112691'                   [InscricaoMunicipal]  
  --[Prestador]  
  
  --[Tomador]  
  --[IdentificaçãoTomador]  
  --[CpfCnpj]    
  ,T.num_cpf_cnpj [CpfCnpj]  
  --[CpfCnpj]  
  ,(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN   
   ''   
  ELSE   
   replace(NUM_Insc_Munic,'.','')   
  END)                    [CpfInscricaoMunicipal]  
  --[IdentificaçãoTomador]  
  ,[DBO].[FRemoveAcentuacao](T.nome_raz_soc)           [RazaoSocial]   
  --[Endereco]  
  ,TE.Rua                    [Endereco]  
  ,(CASE WHEN (TE.numero = '' or TE.numero IS NULL) THEN 'S/N' ELSE TE.numero END) [Numero]  
  ,TE.Compl_End                  [Complemento]  
  ,(CASE WHEN TE.bairro = '' OR TE.bairro IS NULL THEN  
   'Nao Informado'   
  ELSE  
   TE.bairro  
  END)                    [Bairro]  
  ,TE.Cidade                   [Cidade]  
  ,TE.Cod_IBGE                  [CodigoMunicipio]  
  ,I.UF + I.Cod_IBGE                 [CodigoMunicipioEnd]  
  ,TE.UF                    [Uf]   
  ,TE.UF                    [Estado]  
  ,RIGHT('00000000000' + replace(TE.CEP,'-',''),8)         [Cep]  
  --[Endereco]  
  --[CONtato]  
  --(CO.cd_area_fONe + CO.Prefixo + CO.num_fONe) [TelefONe],  
  ,RIGHT('00000000000' + replace(replace(ISNULL((CO.cd_area_fone + CO.Prefixo + CO.num_fone),'00000000'),'.',''),'-',''),11) [Telefone]  
  --[CONtato]   
  --[Email]  
  ,co.Compl_Fone                  [Email]  
  --[CONtato]    
  --[Tomador]  
  ,BNF.Ref_Acesso                  Ref_Acesso        
  ,'0.00'                    ValorCargaTributaria  
  ,ISNULL(TE.Pais,'')                 Pais  
 FROM   
  base_nota_fiscal BNF  
  INNER JOIN pessoa T (NOLOCK)  
   ON T.cd_pes = BNF.cd_pes   
  LEFT JOIN Endereco TE (NOLOCK)  
   ON TE.cd_pes = T.cd_pes   
   AND TE.cd_tp_end = 'COM'  
  LEFT JOIN comunicacao CO (NOLOCK)  
   ON CO.cd_pes = T.cd_pes   
   AND Co.cd_tp_com ='NF1'  
-- Alterado por antonio 12-07-2023
-- LEFT JOIN IBGE_Municipios_BR I (NOLOCK)   
   LEFT JOIN vwATL_IBGE_Municipios_BR I (NOLOCK)   
   ON I.Nome_Município = TE.cidade   
   AND I.UF_Descr_Red = TE.UF   
 WHERE  
  BNF.Ref_Acesso = 'J'      
  AND BNF.Cd_Status <> 2   
  AND BNF.RPS_Envio <> 1     
  --AND ((emissao between @dtInicial AND @dtFinal) OR   
  AND Nota_Fiscal = @NF  
 END  
   
 UPDATE   
  T    
 SET   
  [ValorLiquidONfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis] - [ValorIssRetido]  
 FROM   
  @Nota AS T  
 --WHERE  
 -- T.Cidade <> 'São Caetano do Sul'  
  
 BEGIN   
  IF NOT EXISTS (   
      SELECT * FROM Base_Envio_LoteRps B (NOLOCK)  
      INNER JOIN @Nota N   
       ON N.Numero = B.Numero   
       AND N.Ref_Acesso = B.Ref_Acesso  
     )    
  INSERT INTO Base_Envio_LoteRps 
  (Numero,Serie,Tipo,DataEmissao,NaturezaOperacao,RegimeEspecialTributacao,OptanteSimplesNacional,IncentivadorCultural,[Status],
ValorServicos,ValorPis,ValorCofins,ValorInss,ValorIr,ValorCsll,IssRetido,ValorIssRetido,ValorIss,BaseCalculo,Aliquota,ValorLiquidoNfse,
ItemListaServico,CodigoCnae,CodigoTributacaoMunicipio,CodigoMunicipio,Discriminacao,MunicipioPrestacaoServico,Cnpj,
InscricaoMunicipal,CpfCnpj,CpfInscricaoMunicipal,RazaoSocial,Endereco,NumeroEnd,Complemento,Bairro,Cidade,CodigoMunicipioE,
CodigoMunicipioEnd,Uf,Estado,Cep,Telefone,Email,Ref_Acesso,ValorCargaTributaria,Pais)
  SELECT * FROM @Nota     
 END  
  
 SELECT * FROM @Nota  


 --,Competencia,CodigoPais,ExigibilidadeISS)

  
  
GO
