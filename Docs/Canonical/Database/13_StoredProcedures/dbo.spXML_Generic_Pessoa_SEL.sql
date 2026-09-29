SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spXML_Generic_Pessoa_SEL]
(
    @strSystemCode VARCHAR(10)  
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cd_pes         VARCHAR(10),
            @CNPJ           VARCHAR(15),
            @Apelido        VARCHAR(20),
            @Nome_raz_Soc   VARCHAR(60),  
            @num_cpf_cnpj   VARCHAR(50),  
            @cd_tp_Ativ     VARCHAR(3),
            @Cd_Tp_Grupo    VARCHAR(3),
            @Cd_Usuario     VARCHAR(15),
            @Dt_Cad         CHAR(10),
            @Desat_Pes      CHAR(1),
            @Obs_Pes        VARCHAR(200),
            @Num_RG_IE      VARCHAR(16),
            @Num_Insc_Munic VARCHAR(20),
            @AccountNum     VARCHAR(50),
            
            -- Endereço
            @Tipo_Endereco  VARCHAR(50),
            @Rua            VARCHAR(50),
            @Numero         VARCHAR(50),
            @Compl_End      VARCHAR(50),
            @CEP            VARCHAR(50),
            @Bairro         VARCHAR(50),
            @Cidade         VARCHAR(50),
            @UF             VARCHAR(50),
            @pais           VARCHAR(50),

            -- Grupo
            @grupo          VARCHAR(50),
            @Cd_Planta      VARCHAR(20),
            @Cd_Vendor      VARCHAR(20);


    DECLARE @JOBs TABLE 
    (
        cd_pes          VARCHAR(50),
        Apelido         VARCHAR(30),
        Nome_raz_Soc    VARCHAR(200),  
        num_cpf_cnpj    VARCHAR(50),  
        cd_tp_Ativ      VARCHAR(3),
        Cd_Tp_Grupo     VARCHAR(3),
        Cd_Usuario      VARCHAR(15),
        Dt_Cad          CHAR(10),
        Desat_Pes       CHAR(1),
        Obs_Pes         VARCHAR(200),
        Num_RG_IE       VARCHAR(20),
        Num_Insc_Munic  VARCHAR(20),
        AccountNum      VARCHAR(50),
        
        -- Endereço
        Tipo_Endereco   VARCHAR(50),
        Rua            VARCHAR(80),
        Numero         VARCHAR(50),
        Compl_End      VARCHAR(50),
        CEP            VARCHAR(50),
        Bairro         VARCHAR(50),
        Cidade         VARCHAR(50),
        UF             VARCHAR(50),
        Pais           VARCHAR(50),

        -- Grupo
        Grupo          VARCHAR(50),
        Cd_Planta      VARCHAR(20),
        System_Code    VARCHAR(10),
        Dt_Pessoa      DATETIME
    );

	   IF @strSystemCode = '21'
    BEGIN
        -- Inserindo dados na tabela temporária
        SELECT DISTINCT
            NULL AS cd_pes,
            --LEFT(P.PartyName, 20 - LEN(ISNULL(P.PartyPostalCode, 'XXXX'))) 
            --    + '-' + ISNULL(P.PartyPostalCode, 'XXXX') AS Apelido,
			LEFT(P.PartyName, 20 - LEN(ISNULL(P.PartyPostalCode, 'XXXX')) - 1) 
			+ '-' + ISNULL(P.PartyPostalCode, 'XXXX') AS Apelido,
            LEFT(P.PartyName, 60) AS Nome_raz_Soc,
            NULL AS Num_CPF_CNPJ,
            'GRL' AS cd_tp_Ativ,
            'GRL' AS Cd_Tp_Grupo,
            'ATL' AS cd_usuario,
            CONVERT(VARCHAR(10), GETDATE(), 103) AS Dt_Cad,
            'N' AS Desat_Pes,
            'Integration Ashland' AS Obs_Pes,
            NULL AS Num_Rg_IE,
            NULL AS Num_Insc_Munic,
            P.ID_Req AS AccountNum,
            
            -- Endereço
            'Comercial' AS Tipo_Endereco,
            ISNULL(LEFT(P.PartyAddress, 40), 'Not Informed') AS Rua,
            '' AS Numero,         
            '' AS Compl_End,         
            ISNULL(P.PartyPostalCode, '00000000') AS CEP,         
            '' AS Bairro,
            ISNULL(P.PartyCity, 'N/A') AS Cidade,
            ISNULL(P.PartyStateProv, 'NA') AS UF,
            COALESCE(PA.Nome_Pais, P.PartyCountry) AS Pais,
			PP.Cd_Pes					[Group Code],
			PP.Apelido					[Group Name],
            '' AS Cd_Planta,
            G.SystemCode AS System_Code,
            G.DT_INS_PESSOA AS Dt_Pessoa

        FROM atl_INT.DBO.GIX_Request_Header G WITH (NOLOCK)
        JOIN atl_INT.DBO.GIX_Header_Parties P WITH (NOLOCK) ON P.ID_Req = G.ID_Req 
		join Pessoa PP with(nolock) on PP.cd_pes = 'P000045449'
        --LEFT JOIN Pessoa PP WITH (NOLOCK) ON PP.GIX_HT_Customer = G.Customer
        LEFT JOIN Pais PA WITH (NOLOCK) ON PA.Cd_Pais = P.PartyCountry

        WHERE 
			G.SystemCode = @strSystemCode
			and	G.DT_INS_PESSOA is null
			and P.PartyName is not null
			and LEN(isnull(P.PartyPostalCode,'')) < 15
    END
END
GO
