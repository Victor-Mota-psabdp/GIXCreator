SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BuscaAXXML_Sel]  
(   
 @IDAX bigint,  
 @Num_Proc Varchar(16),  
 @Nome_Tp_Tx Varchar(50),  
 @DC Varchar(1),  
 @Apelido Varchar(20)  
)  
as  
  
Declare @Num_ProcL Varchar(18)  
Declare @Nome_Tp_TxL Varchar(52)  
Declare @DCL Varchar(3)  
Declare @ApelidoL Varchar(22)  
Declare @Reenvio bit  
--Set @Num_Proc = 'EMAET201407002BR'  
--Set @IDAX = '553881'  
--Set @Nome_Tp_Tx = 'Taxa no Destino'  
--Set @DC = @DC  
--Set @Cd_Pes  = @Cd_Pes  
  
if @Num_Proc is not  NULL  
-- Begin  
--  Set @Num_ProcL = '%'  
-- End  
--Else  
 Begin  
  Set @Num_ProcL = @Num_Proc  
 End  
if @Nome_Tp_Tx is not NULL  
-- Begin  
--  Set @Nome_Tp_TxL = '%'  
-- End  
--Else  
 Begin  
  Set @Nome_Tp_TxL = (Select'%' + @Nome_Tp_Tx + '%')  
 End  
If @DC is not NULL  
-- Begin  
--  Set @DCL = '%'  
-- End  
--Else  
 Begin  
  Set @DCL = (Select'%'+ @DC + '%')  
 End  
  
If @ApelidoL is not NULL  
-- Begin  
--  Set @ApelidoL  = '%'  
-- End  
--Else  
 Begin  
  Set @ApelidoL  = (Select'%'+ @Apelido + '%')  
 End  
   
--Print @Num_ProcL   
--Print @Nome_Tp_TxL   
--Print @DCL  
--Print @ApelidoL   
--Select @Num_ProcL  
Set @Reenvio = 0  
select @Reenvio [Resend],AXX.ID_AX[ID AX], AXX.Num_Proc [JOB],TT.Nome_Tp_Tx [Taxa],AXX.DC[D/C], PS.Apelido [Creditor/Debitor],AXI.Valor [Valor],AXX.Cancel,DT_Envio [Envio] 
from AX_DOC_XML_NEW AXX   
join AX_DOC AX on AXX.Id_AX = AX.Id_AX  
join AX_DOC_ITEM AXI on AXX.Id_AX = AXI.Id_AX and AXX.Num_Proc = AXI.Num_Proc and AXX.Cd_Tp_Tx_ATL = AXI.Cd_Tp_Tx_ATL and AXX.DC=AXI.DC  
left join vwCta_Cte CC on AXX.Num_Proc = CC.Num_Proc_hia and AXX.Cd_Tp_Tx_ATL = CC.Cd_Tp_Tx and AXX.DC=CC.DC_hia  
Join Tipo_Taxa TT with(nolock) on AXX.Cd_Tp_Tx_ATL = TT.Cd_Tp_Tx  
Join Pessoa PS with(nolock) on CC.Cd_Cred_Dev_Hia = PS.Cd_Pes  
where ((month(AX.Dt_Documento)>=month(getdate())-1 and year(AX.Dt_Documento)=year(getdate()-1))) and   
(@IDAX is NULL or AXX.Id_AX = @IDAX)   
and (@Num_ProcL is NULL or AXX.Num_proc like @Num_ProcL)  
and (@Nome_TP_TxL is NULL or TT.Nome_Tp_Tx like @Nome_Tp_TxL)  
and (@DCL is NULL or AXX.DC like @DCL)  
and (@ApelidoL is NULL or PS.Apelido like @ApelidoL)  
  
  
--select month(AX.Dt_Vencimento),month(getdate()-1),year(AX.Dt_Vencimento), year(getdate()-1),* from AX_DOC_XML AXX  
--left join AX_DOC AX on AXX.Id_AX = AX.Id_AX  
--left join vwCta_Cte CC on AXX.Num_Proc = CC.Num_Proc_hia and AXX.Cd_Tp_Tx_ATL = CC.Cd_Tp_Tx and AXX.DC=CC.DC_hia  
--where --((month(AX.Dt_Vencimento)>=month(getdate()-1) and year(AX.Dt_Vencimento)=year(getdate()-1))) and  
--AXX.Num_proc like 'EMAET201407002BR'   
  
  
  
  
GO
