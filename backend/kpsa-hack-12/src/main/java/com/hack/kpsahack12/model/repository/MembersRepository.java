package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.Members;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MembersRepository extends JpaRepository<Members, Long> {

    Optional<Members> findById(String id);
}