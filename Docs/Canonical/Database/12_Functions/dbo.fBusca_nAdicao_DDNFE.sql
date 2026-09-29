SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_nAdicao_DDNFE] 
(
@num_proc VARCHAR(100),
@cd_proc_cliente VARCHAR(250)
)
RETURNS VARCHAR(250)
AS
BEGIN
    DECLARE @nseqadic VARCHAR(250);

    SELECT DISTINCT @nseqadic = IPDA.nseqadic
    FROM 
        ATL_BR.dbo.Danfe_Base D with(nolock)
        JOIN ATL_BR.dbo.Danfe_Item I with(nolock) ON I.Id_Danfe = i.id_Item
        JOIN ATL_BR.dbo.Danfe_Item_Produto IPP with(nolock) ON IPP.Id_Danfe = D.Id_Danfe
        JOIN ATL_BR.dbo.Danfe_Item_Prod_DI DI with(nolock) ON DI.Id_Danfe = D.Id_Danfe AND DI.id_item=IPP.id_Item AND IPP.cProd = Di.cProd
        LEFT JOIN ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao IPDA with(nolock) ON IPDA.nDI = DI.nDI AND IPDA.Id_Danfe = DI.Id_Danfe AND IPDA.id_item=DI.id_Item
    WHERE
        D.Num_Proc = @num_proc AND ipp.cprod = @cd_proc_cliente;

    RETURN @nseqadic;
END
GO
