package com.agito.plsqlexecuter.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.agito.plsqlexecuter.service.*;

import java.util.concurrent.CompletableFuture;

@RestController
public class PlsqlController {

    @Autowired
    private PlsqlExecutorService executorService;

    /**
     * Executes the PL/SQL script for a policy.
     *
     * @param policyId the ID of the policy to process
     */
    @GetMapping("/execute-plsql/policy")
    public CompletableFuture<String> executePlsqlForPolicy(@RequestParam Long policyId) {
        return executorService.executePlsqlForPolicyAsync(policyId);
    }

    /**
     * Endpoint to execute PL/SQL script for specific policyId and addendumNumber.
     *
     * @param policyId       the ID of the policy
     * @param addendumNumber the number of the addendum
     */
    @GetMapping("/execute-plsql/policyandaddendum")
    public String executePlsqlForPolicyAndAddendum(
            @RequestParam Long policyId,
            @RequestParam Integer addendumNumber) {
        executorService.executePlsqlForPolicyAndAddendumAsync(policyId, addendumNumber);
        return "PL/SQL execution for policy ID " + policyId + " and addendum number " + addendumNumber + " initiated.";
    }

    /**
     * Endpoint to create a proposal.
     *
     * @param webserviceLogId the ID of the web service log
     * @param proposalNumber  the proposal number
     */
    @GetMapping("/execute-plsql/createProposal")
    public String createProposal(
            @RequestParam Long webserviceLogId,
            @RequestParam String proposalNumber) {
        executorService.createProposalAsync(webserviceLogId, proposalNumber);
        return "Proposal creation initiated with webservicelogid: " + webserviceLogId + ", proposalNumber: " + proposalNumber;
    }

    /**
     * Endpoint to issue policy for vcollect.
     *
     * @param policyId the ID of the policy
     * @param aracitcno the identity number of Agency
     */
    @GetMapping("/execute-plsql/policelestirvc")
    public String policelestirvc(
            @RequestParam Long policyId,
            @RequestParam String aracitcno) {
        executorService.policelestirvcAsync(policyId, aracitcno);
        return "Proposal creation initiated with policy Id: " + policyId + ", identity number of agency: " + aracitcno;
    }
}