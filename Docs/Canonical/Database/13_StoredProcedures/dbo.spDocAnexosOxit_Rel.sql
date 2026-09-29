SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spDocAnexosOxit_Rel]-- '2015-01-01','2015-02-01'
	@DataInicial varchar(10),
	@DataFinal	VArchar(10)
	AS
	
/*-------------------------------------------------------------------------------------------------------------------------
HISTORICO ALTERAÇÃO
. Data:	24/06/2019
. Solicitante: Rebeca Corracini Castro Pessonio
. Desenvolvedor: Alessandra Suzuki Mariano
. Solicitação: Solicitada alteração no Ticket 100-152578 conforme
	. Incluir data "Creation Date" do anexo 204-DUE no relatório "Oxiteno (Docs vs ETD)" 
	. Incluir data "Creation Date" do anexo 065-SAQUE no relatório "Oxiteno (Docs vs ETD)" 
	. Retirar colunas "RE", "DDE" e "BL" do relatório pois não existem mais.



-------------------------------------------------------------------------------------------------------------------------
EXEMPLO EXECUÇÃO
	-- teste do campo DUE preenchido
	-- EMOXT201812143BR
	spDocAnexosOxit_Rel '2019-06-04' ,'2019-06-04' 					
						
	-- teste do campo SAQUE preenchido
	-- EMOXT201905221BR 
	spDocAnexosOxit_Rel '2019-06-05' ,'2019-06-05'  
	
	spDocAnexosOxit_Rel '2019-01-01' ,'2019-01-05'  
-------------------------------------------------------------------------------------------------------------------------
*/
	

--select top 1000 Num_Proc_Lem Job ,  
select Num_Proc_Lem Job ,  
PO.Numero_PO_HEM [Sales Order],   
ETD_Lem ETD ,  
CONVERT(varchar(10),NF.dt_creacao,103) NF,  
CONVERT(varchar(10),COA.dt_creacao,103) COA,  
CONVERT(varchar(10),CO.dt_creacao,103) CO,  
CONVERT(varchar(10),PL.dt_creacao,103) PL,  
CONVERT(varchar(10),CI.dt_creacao,103) CI,  
--CONVERT(varchar(10),RE.dt_creacao,103) RE,  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
--CONVERT(varchar(10),DDE.dt_creacao,103) DDE,   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
--CONVERT(varchar(10),BL.dt_creacao,103) BL,  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
CONVERT(varchar(10),DOC.dt_creacao,103) DOC  
,CONVERT(varchar(10),DUE.dt_creacao,103) DUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão 
,CONVERT(varchar(10),SAQ.dt_creacao,103) SAQUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
  
from LLP_Exp_Mar with( nolock)  
Left Join Doc_Anexos NF with( nolock) on NF.Num_Proc = Num_Proc_Lem and NF.Id_DC = 10   
Left Join Doc_Anexos COA  with( nolock) on COA.Num_Proc = Num_Proc_Lem and COA.Id_DC = 16  
Left Join Doc_Anexos CO with( nolock) on CO.Num_Proc = Num_Proc_Lem and CO.Id_DC = 13   
Left Join Doc_Anexos PL with( nolock) on PL.Num_Proc = Num_Proc_Lem and PL.Id_DC = 11  
Left Join Doc_Anexos CI with( nolock) on CI.Num_Proc = Num_Proc_Lem and CI.Id_DC = 2  
--Left Join Doc_Anexos RE with( nolock) on RE.Num_Proc = Num_Proc_Lem and RE.Id_DC = 4   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos DDE with( nolock) on DDE.Num_Proc = Num_Proc_Lem and DDE.Id_DC = 12   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos BL with( nolock) on BL.Num_Proc = Num_Proc_Lem and BL.Id_DC = 44  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
Left Join Doc_Anexos DOC with( nolock) on DOC.Num_Proc = Num_Proc_Lem and DOC.Id_DC = 20  
Left Join PO_HEM  PO  with(nolock) on PO.Num_Proc_HEM = Num_Proc_Lem and PO.ID_DC = 3 
  
Left Join Doc_Anexos DUE with( nolock) on DUE.Num_Proc = Num_Proc_Lem and DUE.Id_DC = 204  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
Left Join Doc_Anexos SAQ with( nolock) on SAQ.Num_Proc = Num_Proc_Lem and SAQ.Id_DC = 65  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
 
   
Where  
 Num_Proc_Lem like 'EMOXT%' and  ETD_Lem between @DataInicial and @DataFinal  
   
 Union all  
   
 select  Num_Proc_Leo Job ,  
PO.Numero_PO_HEO [Sales Order],    
ETD_Leo ETD ,  
CONVERT(varchar(10),NF.dt_creacao,103) NF,  
CONVERT(varchar(10),COA.dt_creacao,103) COA,  
CONVERT(varchar(10),CO.dt_creacao,103) CO,  
CONVERT(varchar(10),PL.dt_creacao,103) PL,  
CONVERT(varchar(10),CI.dt_creacao,103) CI,  
--CONVERT(varchar(10),RE.dt_creacao,103) RE,   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--CONVERT(varchar(10),DDE.dt_creacao,103) DDE,   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--CONVERT(varchar(10),BL.dt_creacao,103) BL,	-- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
CONVERT(varchar(10),DOC.dt_creacao,103) DOC  
,CONVERT(varchar(10),DUE.dt_creacao,103) DUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
,CONVERT(varchar(10),SAQ.dt_creacao,103) SAQUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
  
from LLP_Exp_out with( nolock)  
Left Join Doc_Anexos NF with( nolock) on NF.Num_Proc = Num_Proc_Leo and NF.Id_DC = 10   
Left Join Doc_Anexos COA  with( nolock) on COA.Num_Proc = Num_Proc_Leo and COA.Id_DC = 16  
Left Join Doc_Anexos CO with( nolock) on CO.Num_Proc = Num_Proc_Leo and CO.Id_DC = 13   
Left Join Doc_Anexos PL with( nolock) on PL.Num_Proc = Num_Proc_Leo and PL.Id_DC = 11  
Left Join Doc_Anexos CI with( nolock) on CI.Num_Proc = Num_Proc_Leo and CI.Id_DC = 2  
--Left Join Doc_Anexos RE with( nolock) on RE.Num_Proc = Num_Proc_Leo and RE.Id_DC = 4 -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos DDE with( nolock) on DDE.Num_Proc = Num_Proc_Leo and DDE.Id_DC = 12  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos BL with( nolock) on BL.Num_Proc = Num_Proc_Leo and BL.Id_DC = 44   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
Left Join Doc_Anexos DOC with( nolock) on DOC.Num_Proc = Num_Proc_Leo and DOC.Id_DC = 20  
Left Join PO_HEO  PO  with(nolock) on PO.Num_Proc_HEO = Num_Proc_Leo and PO.ID_DC = 3  
Left Join Doc_Anexos DUE with( nolock) on DUE.Num_Proc = Num_Proc_Leo and DUE.Id_DC = 204  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
Left Join Doc_Anexos SAQ with( nolock) on SAQ.Num_Proc = Num_Proc_Leo and SAQ.Id_DC = 65  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
   
 
Where  
 Num_Proc_Leo like 'EOOXT%' and  ETD_Leo between @DataInicial and @DataFinal  
   
 Union all  
   
 select  Num_Proc_lea Job ,  
PO.Numero_PO_HEA [Sales Order],   
ETD_lea ETD ,  
CONVERT(varchar(10),NF.dt_creacao,103) NF,  
CONVERT(varchar(10),COA.dt_creacao,103) COA,  
CONVERT(varchar(10),CO.dt_creacao,103) CO,  
CONVERT(varchar(10),PL.dt_creacao,103) PL,  
CONVERT(varchar(10),CI.dt_creacao,103) CI,  
--CONVERT(varchar(10),RE.dt_creacao,103) RE,   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--CONVERT(varchar(10),DDE.dt_creacao,103) DDE,   -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--CONVERT(varchar(10),BL.dt_creacao,103) BL,	-- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
CONVERT(varchar(10),DOC.dt_creacao,103) DOC 
,CONVERT(varchar(10),DUE.dt_creacao,103) DUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
,CONVERT(varchar(10),SAQ.dt_creacao,103) SAQUE -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
  
from LLP_Exp_aer with( nolock)  
Left Join Doc_Anexos NF with( nolock) on NF.Num_Proc = Num_Proc_lea and NF.Id_DC = 10   
Left Join Doc_Anexos COA  with( nolock) on COA.Num_Proc = Num_Proc_lea and COA.Id_DC = 16  
Left Join Doc_Anexos CO with( nolock) on CO.Num_Proc = Num_Proc_lea and CO.Id_DC = 13   
Left Join Doc_Anexos PL with( nolock) on PL.Num_Proc = Num_Proc_lea and PL.Id_DC = 11  
Left Join Doc_Anexos CI with( nolock) on CI.Num_Proc = Num_Proc_lea and CI.Id_DC = 2  
--Left Join Doc_Anexos RE with( nolock) on RE.Num_Proc = Num_Proc_lea and RE.Id_DC = 4  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos DDE with( nolock) on DDE.Num_Proc = Num_Proc_lea and DDE.Id_DC = 12 -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada
--Left Join Doc_Anexos BL with( nolock) on BL.Num_Proc = Num_Proc_lea and BL.Id_DC = 44  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada retirada 
Left Join Doc_Anexos DOC with( nolock) on DOC.Num_Proc = Num_Proc_lea and DOC.Id_DC = 20  
Left Join PO_HEA  PO  with(nolock) on PO.Num_Proc_HEA = Num_Proc_Lea and PO.ID_DC = 3  
Left Join Doc_Anexos DUE with( nolock) on DUE.Num_Proc = Num_Proc_Lea and DUE.Id_DC = 204  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
Left Join Doc_Anexos SAQ with( nolock) on SAQ.Num_Proc = Num_Proc_Lea and SAQ.Id_DC = 65  -- Alessandra 24/06/2019 - Ticket 100-152578 - Solicitada inclusão
 
Where  
 Num_Proc_lea like 'EAOXT%' and  ETD_lea between @DataInicial and @DataFinal  
   

	

GO
