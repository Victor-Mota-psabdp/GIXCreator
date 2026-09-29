SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu incluido como where os parametros e LEN =16
--18-02-2026 - antonio - separar a opção status de fechamento de processo diferente BDP/Pibernat 
-- UNion para pegar todos os processo que o usuario fechou antes do job ser atualizado aqui no ATL 
-- ficou como conclusão operacional e a data de atualização no ATL  null
--spATL_JSON_FComex_JobReferences_Line_Sel 0,'',1,'E'
CREATE procedure [dbo].[spATL_JSON_FComex_JobReferences_Line_TestInProd_Sel] -- 

	@Id_Processo [bigint],
	@Processo varchar(16),
	@Id_Empresa [bigint],
    @tipo varchar(1)

/*
-- tipos de pesquisa 
-- B - Processos unicos, processados ou não no ATL   
-- C - todos os registros que a data de desmbaraço esta nula de todas as empresas 
-- D - procurar por numero do processo 
-- 02-01-2026 - ajustar no status 
-- E - todos os registros que a data de desmbaraço esta nula por empresa escolhida 

*/

AS
if @tipo = 'E'
		Begin 
		    if @Id_Empresa = 1 -- BDP 
   			   begin 
					Select distinct
  						J.[Id_Processo],
						J.[Processo],
						J.[Num_Proc],
						J.[Order],
						J.[Master],
						J.[House],
						J.[Channel],
						J.[Terminal],
						J.[Incoterm],
						Case when isnull(J.[NumeroDoc],'0') = '0' then null else
							Case when J.[Cd_Moeda_Frete] = '0' then NULL else J.[Cd_Moeda_Frete] End END	[Cd_Moeda_Frete],
						Case when isnull(J.[NumeroDoc],'0') = '0' then null else
							Case when J.[Valor_Frete] = '0' then NULL else J.[Valor_Frete] End	END		[Valor_Frete],
						J.[TipoDoc],
						Case when J.[NumeroDoc] = '0' then NULL else J.[NumeroDoc] End				[NumeroDoc],
						Case when J.[DataDi] is null then null else
							CONVERT(varchar, CONVERT(datetime, J.[DataDi], 105), 23) End			 [DataDi],
						--J.[DataDi], 
						--J.[DataCi],
						CONVERT(varchar(10), TRY_CONVERT(datetime, J.[DataCi], 120), 23) AS [DataCi],
						Case when J.[Transmissao] = '0' then NULL else J.[Transmissao] End				[Transmissao],
				--J.[DataDesembaraco],
CONVERT(varchar(10), TRY_CONVERT(datetime, J.[DataDesembaraco], 120), 23) AS DataDesembaraco,				--		CASE 
    --WHEN J.[DataDesembaraco] IS NULL THEN NULL
    --ELSE CONVERT(varchar, CONVERT(datetime, J.[DataDesembaraco], 105), 23) End AS [DataDesembaraco],
						J.[PresencaDeCarga],
						Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
							Case when J.[Paridade] = '0' then '0' else J.[Paridade] End END				[Paridade],
						Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
							Case when J.[ParidadeDolar] = '0' then NULL else J.[ParidadeDolar] End	END	[ParidadeDolar],
						J.[SystemCode],
						J.[Message],
						J.[Situacao],
						J.[Id_Empresa],
						EMP.Nome_Empresa
						,HOU.ID_Status				
					from ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock)
					join ATL_INT.dbo.Exchange_FComex Exc with(nolock) on  Exc.num_proc = J.Num_proc and  Exc.Id_Empresa = J.Id_Empresa and Exc.Processo = J.Processo
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
					join ATL_INT.dbo.Empresa_FComex EMP with(nolock) on EMP.Id_Empresa = J.Id_Empresa
					WHERE
						--J.NumeroDoc in ('25/2089852-5') and
							J.Dt_Ins_Atl is null			 
							and  J.Id_Empresa = @Id_Empresa
					
							--23-12-2025 Antonio não traz se o job ta null no status 
							-- and HOU.ID_Status not in (5,6,9)

							and isnull(HOU.ID_Status,0) not in (5,6,9)

							and j.situacao not like '%Cancelado%'
--							and j.situacao  <> 'Num_Proc not Found!'
							and j.situacao  <> 'Conclusão Operacional'  -- BDP 8	Close Financial Item
					
						---na produção não deixar processar estes jobs que foram criado no FazComex de produção como teste
						-- para não alterar os dados no ATL
 						and  J.Id_Processo not in(
						11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,
						28439,29159,29167,29175,29214,29235,29368,29727,30436,30824,31671,31700,32365,32532,
						32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,
						39168,39169,39189,39666,39667,39668,39691,39959, 126940) 
		--39162,--39738,-39882,--,40024	--47793,				--47956)					
		--					caso precise rodar um job especifico com urgencia desabilitar isso aqui
		--					and j.Num_Proc = 'IMEXO202506006BR'
		--				order by j.num_proc asc 

			Union 

					Select distinct
  						J.[Id_Processo],
						J.[Processo],
						J.[Num_Proc],
						J.[Order],
						J.[Master],
						J.[House],
						J.[Channel],
						J.[Terminal],
						J.[Incoterm],
						Case when isnull(J.[NumeroDoc],'0') = '0' then null else
							Case when J.[Cd_Moeda_Frete] = '0' then NULL else J.[Cd_Moeda_Frete] End END	[Cd_Moeda_Frete],
						Case when isnull(J.[NumeroDoc],'0') = '0' then null else
							Case when J.[Valor_Frete] = '0' then NULL else J.[Valor_Frete] End	END		[Valor_Frete],
						J.[TipoDoc],
						Case when J.[NumeroDoc] = '0' then NULL else J.[NumeroDoc] End				[NumeroDoc],
						Case when J.[DataDi] is null then null else
							CONVERT(varchar, CONVERT(datetime, J.[DataDi], 105), 23) End			 [DataDi],
						--J.[DataDi], 
						J.[DataCi],
						--Case when J.[DataCi] is null then null else
						--	CONVERT(varchar, CONVERT(datetime, J.[DataCi], 105), 23) End			 [DataCi],
						Case when J.[Transmissao] = '0' then NULL else J.[Transmissao] End				[Transmissao],
						J.[DataDesembaraco],
						--Case when J.[DataDesembaraco] is null then null else
						--	CONVERT(varchar, CONVERT(datetime, J.[DataDesembaraco], 105), 23) End	[DataDesembaraco],
						J.[PresencaDeCarga],
						Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
							Case when J.[Paridade] = '0' then '0' else J.[Paridade] End END				[Paridade],
						Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
							Case when J.[ParidadeDolar] = '0' then NULL else J.[ParidadeDolar] End	END	[ParidadeDolar],
						J.[SystemCode],
						J.[Message],
						J.[Situacao],
						J.[Id_Empresa],
						EMP.Nome_Empresa
						,HOU.ID_Status				
					from ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock)
					join ATL_INT.dbo.Exchange_FComex Exc with(nolock) on  Exc.num_proc = J.Num_proc and  Exc.Id_Empresa = J.Id_Empresa and Exc.Processo = J.Processo
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
					join ATL_INT.dbo.Empresa_FComex EMP with(nolock) on EMP.Id_Empresa = J.Id_Empresa
					WHERE
						
						--J.NumeroDoc in ('25/2089852-5') and
							J.Dt_Ins_Atl is null			 
							and  J.Id_Empresa =  @Id_Empresa
					
							--23-12-2025 Antonio não traz se o job ta null no status 
							-- and HOU.ID_Status not in (5,6,9)

							and isnull(HOU.ID_Status,0) not in (5,6,9)

							and j.situacao not like '%Cancelado%'
--							and j.situacao  <> 'Num_Proc not Found!'
							and j.situacao  = 'Conclusão Operacional'  -- BDP 8	Close Financial Item
					
						---na produção não deixar processar estes jobs que foram criado no FazComex de produção como teste
						-- para não alterar os dados no ATL
 						and  J.Id_Processo not in(
						11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,
						28439,29159,29167,29175,29214,29235,29368,29727,30436,30824,31671,31700,32365,32532,
						32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,
						39168,39169,39189,39666,39667,39668,39691,39959, 126940) 
		--39162,--39738,-39882,--,40024	--47793,				--47956)					
		--					caso precise rodar um job especifico com urgencia desabilitar isso aqui
							and j.Num_Proc = 'IMSOL202601003BR'
						order by j.num_proc asc 
               end
 
			if @Id_Empresa = 2 -- Pibernat  
		       begin 
   						Select distinct
  							J.[Id_Processo],
							J.[Processo],
							J.[Num_Proc],
							J.[Order],
							J.[Master],
							J.[House],
							J.[Channel],
							J.[Terminal],
							J.[Incoterm],
							Case when isnull(J.[NumeroDoc],'0') = '0' then null else
								Case when J.[Cd_Moeda_Frete] = '0' then NULL else J.[Cd_Moeda_Frete] End END	[Cd_Moeda_Frete],
							Case when isnull(J.[NumeroDoc],'0') = '0' then null else
								Case when J.[Valor_Frete] = '0' then NULL else J.[Valor_Frete] End	END		[Valor_Frete],
							J.[TipoDoc],
							Case when J.[NumeroDoc] = '0' then NULL else J.[NumeroDoc] End				[NumeroDoc],
							Case when J.[DataDi] is null then null else
								CONVERT(varchar, CONVERT(datetime, J.[DataDi], 105), 23) End			 [DataDi],
							--J.[DataDi], 
							J.[DataCi],
							--Case when J.[DataCi] is null then null else
							--	CONVERT(varchar, CONVERT(datetime, J.[DataCi], 105), 23) End			 [DataCi],
							Case when J.[Transmissao] = '0' then NULL else J.[Transmissao] End				[Transmissao],
							J.[DataDesembaraco],
							--Case when J.[DataDesembaraco] is null then null else
							--	CONVERT(varchar, CONVERT(datetime, J.[DataDesembaraco], 105), 23) End	[DataDesembaraco],
							J.[PresencaDeCarga],
							Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
								Case when J.[Paridade] = '0' then '0' else J.[Paridade] End END				[Paridade],
							Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
								Case when J.[ParidadeDolar] = '0' then NULL else J.[ParidadeDolar] End	END	[ParidadeDolar],
							J.[SystemCode],
							J.[Message],
							J.[Situacao],
							J.[Id_Empresa],
							EMP.Nome_Empresa
							,HOU.ID_Status				
						from ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock)
						join ATL_INT.dbo.Exchange_FComex Exc with(nolock) on  Exc.num_proc = J.Num_proc and  Exc.Id_Empresa = J.Id_Empresa and Exc.Processo = J.Processo
						join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
						join ATL_INT.dbo.Empresa_FComex EMP with(nolock) on EMP.Id_Empresa = J.Id_Empresa
						WHERE
							--J.NumeroDoc in ('25/2089852-5') and
								J.Dt_Ins_Atl is null			 
								and  J.Id_Empresa = @Id_Empresa
					
								--23-12-2025 Antonio não traz se o job ta null no status 
								-- and HOU.ID_Status not in (5,6,9)

								and isnull(HOU.ID_Status,0) not in (5,6,9)

								and j.situacao not like '%Cancelado%'
			--					and j.situacao  <> 'Num_Proc not Found!'
								and j.situacao  <> 'faturado'               -- Pibernat  (  
					
							---na produção não deixar processar estes jobs que foram criado no FazComex de produção como teste
							-- para não alterar os dados no ATL
 							and  J.Id_Processo not in(
							11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,
							28439,29159,29167,29175,29214,29235,29368,29727,30436,30824,31671,31700,32365,32532,
							32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,
							39168,39169,39189,39666,39667,39668,39691,39959,126940) 
							--39162,--39738,-39882,--,40024	--47793,				--47956)					
			--caso precise rodar um job especifico com urgencia desabilitar isso aqui
			--				and j.Num_Proc = 'IMEXO202506006BR'

         Union 
 						Select distinct
  							J.[Id_Processo],
							J.[Processo],
							J.[Num_Proc],
							J.[Order],
							J.[Master],
							J.[House],
							J.[Channel],
							J.[Terminal],
							J.[Incoterm],
							Case when isnull(J.[NumeroDoc],'0') = '0' then null else
								Case when J.[Cd_Moeda_Frete] = '0' then NULL else J.[Cd_Moeda_Frete] End END	[Cd_Moeda_Frete],
							Case when isnull(J.[NumeroDoc],'0') = '0' then null else
								Case when J.[Valor_Frete] = '0' then NULL else J.[Valor_Frete] End	END		[Valor_Frete],
							J.[TipoDoc],
							Case when J.[NumeroDoc] = '0' then NULL else J.[NumeroDoc] End				[NumeroDoc],
							Case when J.[DataDi] is null then null else
								CONVERT(varchar, CONVERT(datetime, J.[DataDi], 105), 23) End			 [DataDi],
							--J.[DataDi], 
							J.[DataCi],
							--Case when J.[DataCi] is null then null else
							--	CONVERT(varchar, CONVERT(datetime, J.[DataCi], 105), 23) End			 [DataCi],
							Case when J.[Transmissao] = '0' then NULL else J.[Transmissao] End				[Transmissao],
							J.[DataDesembaraco],
							--Case when J.[DataDesembaraco] is null then null else
							--	CONVERT(varchar, CONVERT(datetime, J.[DataDesembaraco], 105), 23) End	[DataDesembaraco],
							J.[PresencaDeCarga],
							Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
								Case when J.[Paridade] = '0' then '0' else J.[Paridade] End END				[Paridade],
							Case when isnull(J.[NumeroDoc],'0') = '0' then '0' else
								Case when J.[ParidadeDolar] = '0' then NULL else J.[ParidadeDolar] End	END	[ParidadeDolar],
							J.[SystemCode],
							J.[Message],
							J.[Situacao],
							J.[Id_Empresa],
							EMP.Nome_Empresa
							,HOU.ID_Status				
						from ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock)
						join ATL_INT.dbo.Exchange_FComex Exc with(nolock) on  Exc.num_proc = J.Num_proc and  Exc.Id_Empresa = J.Id_Empresa and Exc.Processo = J.Processo
						join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
						join ATL_INT.dbo.Empresa_FComex EMP with(nolock) on EMP.Id_Empresa = J.Id_Empresa
						WHERE
							--J.NumeroDoc in ('25/2089852-5') and
								J.Dt_Ins_Atl is null			 
								and  J.Id_Empresa = @Id_Empresa
					
								--23-12-2025 Antonio não traz se o job ta null no status 
								-- and HOU.ID_Status not in (5,6,9)

								and isnull(HOU.ID_Status,0) not in (5,6,9)

								and j.situacao not like '%Cancelado%'
			--					and j.situacao  <> 'Num_Proc not Found!'
								and j.situacao  = 'faturado'               -- Pibernat    
					
							---na produção não deixar processar estes jobs que foram criado no FazComex de produção como teste
							-- para não alterar os dados no ATL
 							and  J.Id_Processo not in(
							11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,
							28439,29159,29167,29175,29214,29235,29368,29727,30436,30824,31671,31700,32365,32532,
							32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,
							39168,39169,39189,39666,39667,39668,39691,39959,126940) 
							--39162,--39738,-39882,--,40024	--47793,				--47956)					
			--caso precise rodar um job especifico com urgencia desabilitar isso aqui
							and j.Num_Proc = 'IMSOL202601003BR'
							order by j.num_proc asc 
			   end 
			   END
GO
