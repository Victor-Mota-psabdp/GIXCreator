SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedidoXJOB_Sel]  
   
 @cd_pedido as int  
  
AS  
  
select   
 PD.Cd_pedido,  
 Num_Pedido,  
 BB.Apelido Buyer,   
 SS.Apelido Seller,   
 TM.Nome_Tp_Moeda,    
 org.Nome_Pais Pais_Origem,  
 dst.Nome_Pais Pais_Destino,  
 Status,  
 SUM(P.Peso_Bruto_TOT) Peso_Bruto,  
 SUM(P.Peso_Liquido_TOT) Peso_Liquido,  
   
 --C16.Campo_Dados   
 L16.Nome_Local Origin,  
 --C17.Campo_Dados   
 L17.Nome_Local Destination,  
   
 PD.cd_modal Modal,  
   
 --FCL (Full Container),Not assigned,Air Cargo,ISO Tank Sea (FCL),  
 --TL (Full Truckload) (FCL),LCL (Part Container),Deep Sea Vessel (Granel)  
 (case when c20.Campo_Dados = 'FCL (Full Container)'    
  or c20.Campo_Dados = 'ISO Tank Sea'   
  or c20.Campo_Dados = 'TL (Full Truckload)' then 'FCL'  
  else  
   (case when c20.Campo_Dados = 'Air Cargo'   
    or c20.Campo_Dados = 'LCL (Part Container)'  then 'LCL'  
    else  
     (case when c20.Campo_Dados = 'Deep Sea Vessel' then 'BULK'      
  end)end)end)[tp_carga],
  PD.Selling_SAP [selling_sap]    
    
from   
 pedido PD with(nolock)  
 join Pedido_Det P with(nolock) on P.Cd_Pedido = PD.Cd_pedido  
 Join Pessoa BB with(nolock) on BB.cd_pes=PD.cd_buyer  
 Join Pessoa SS with(nolock) on SS.cd_pes=PD.cd_seller  
 Join Pais Org with(nolock) on Org.cd_pais=PD.cd_pais_org  
 Join Pais Dst with(nolock) on Dst.cd_pais=PD.cd_pais_dst  
 left join Tipo_Moeda TM with(nolock) on TM.Cd_Tp_Moeda = PD.cd_tp_moeda  -- Alessandra 05/07/2019 - 100-185868 - Retirada das travas
 left join Campo_Ordem C16 with(nolock) on C16.Cd_Pedido = PD.Cd_pedido and C16.Id_Campo = 16  
 left join Localidade L16 with(nolock) on L16.Nome_Local = C16.Campo_Dados  
 left join Campo_Ordem C17 with(nolock) on C17.Cd_Pedido = PD.Cd_pedido and C17.Id_Campo = 17  
 left join Localidade L17 with(nolock) on L17.Nome_Local = C17.Campo_Dados  
 left join Campo_Ordem C20 on C20.Cd_Pedido = PD.Cd_pedido and C20.Id_Campo = 20    
Where  
 PD.Cd_pedido = @cd_pedido  
Group by   
 PD.Cd_pedido,Num_Pedido,BB.Apelido,SS.Apelido,TM.Nome_Tp_Moeda,org.Nome_Pais,  
 dst.Nome_Pais,Status,C16.Campo_Dados,C17.Campo_Dados,L16.Nome_Local,L17.Nome_Local,  
 PD.cd_modal,c20.Campo_Dados ,pd.Selling_SAP 
  
  
  
   
  
  
  
  
  
  
  
  
GO
