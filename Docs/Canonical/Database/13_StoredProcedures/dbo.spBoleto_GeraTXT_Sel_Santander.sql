SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE Procedure [dbo].[spBoleto_GeraTXT_Sel_Santander]--'IACSR201301009BRB'  
   
as  
 select  
  B.FatCod + ' TX ' + isnull(convert(varchar,[dbo].[fBusca_CampoCliente](left(B.FatCod,16),31)),'') Fatura,  
  dt_boleto,  
  nome_usuario solicitante,  
  P.nome_raz_soc cliente,  
  cd_boleto referente ,  
  valor,  
  FatDtVenc Vencimento,  
  inscricao_numero,  
  agencia_cedente,  
  conta_cedente,  
  cd_instrucao_01,  
  cd_instrucao_02,  
  P.num_cpf_cnpj,  
  DBO.FRemoveCaracteresEspeciais(isnull(Rua,'') + ',' + isnull(numero,'') + isnull(compl_end,'')) rua,  
  DBO.FRemoveCaracteresEspeciais(isnull(Bairro,'')) Bairro,  
  DBO.FRemoveCaracteresEspeciais(isnull(replace(CEP,'-',''),'')) CEP,  
  DBO.FRemoveCaracteresEspeciais(isnull(Cidade,'')) Cidade,  
  DBO.FRemoveCaracteresEspeciais(isnull(UF,'')) UF     
 from boleto B  
  join usuario U on U.cd_usuario = B.cd_usuario  
  join pessoa P on P.cd_pes = B.cd_pes  
  left join endereco E on E.cd_pes = B.cd_pes and cd_tp_end = 'COM'  
  join fatura F on F.fatcod = B.fatcod  
 where   
--  cd_boleto = 07260002  
  dt_emissao_txt is null  
  OR dt_emissao_txt >= GETDATE()-5
  
   
 UNION ALL  
   
 select  
  B.FatCod + ' TX ' + isnull(convert(varchar,[dbo].[fBusca_CampoCliente](left(B.FatCod,16),31)),'') Fatura,  
  dt_boleto,  
  nome_usuario solicitante,  
  P.nome_raz_soc cliente,  
  cd_boleto referente ,  
  valor,  
  Vencimento Vencimento,  
  inscricao_numero,  
  agencia_cedente,  
  conta_cedente,  
  cd_instrucao_01,  
  cd_instrucao_02,  
  P.num_cpf_cnpj,    
  DBO.FRemoveCaracteresEspeciais(isnull(NF.Endereco,'') + ',' + isnull(NF.Numero,'') + isnull(E.Compl_End,'')) rua,  
  DBO.FRemoveCaracteresEspeciais(isnull(NF.Bairro,'')) Bairro,  
  DBO.FRemoveCaracteresEspeciais(isnull(replace(NF.CEP,'-',''),'')) CEP,  
  DBO.FRemoveCaracteresEspeciais(isnull(NF.Cidade,'')) Cidade,  
  DBO.FRemoveCaracteresEspeciais(isnull(NF.UF,'')) UF     
 from boleto B  
  join usuario U on U.cd_usuario = B.cd_usuario  
  join pessoa P on P.cd_pes = B.cd_pes  
  left join endereco E on E.cd_pes = B.cd_pes and cd_tp_end = 'COM'  
  join NF_Fatura NF on NF.Numero_Fat = B.fatcod  
  where   
  dt_emissao_txt is null  
  OR dt_emissao_txt >= GETDATE()-5
 order by 5  
    
GO
